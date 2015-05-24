function trb.split_app_base_name {
    BASE_NAME=${1%/*}
    APP_NAME=${1#*/}

    if [ -z "$APP_NAME" ] ; then
        APP_NAME=BASE_NAME
    fi
}


function trb.venv_dir {
    trb.split_app_base_name $1

    echo "$PROJECTS_PATH/$BASE_NAME/venv-$APP_NAME"
}


function trb.project_env {
    trb.split_app_base_name $1

    echo "$PROJECTS_PATH/$BASE_NAME/.$APP_NAME.env"
}


function trb.open_python_project {
    trb.split_app_base_name $1

    PROJECT_DIR=$PROJECTS_PATH/$BASE_NAME/$APP_NAME
    VENV_DIR=`trb.venv_dir $1`

    if [ -e `trb.project_env $1` ] ; then
        source `trb.project_env $1`
    fi

    cd $PROJECT_DIR
    source $VENV_DIR/bin/activate
}


function trb.create_python_project {
    trb.split_app_base_name $1

    VENV_DIR=`trb.venv_dir $1`
    ALIAS="trb.open_python_project $1"

    pushd $PROJECTS_PATH
    mkdir $BASE_NAME

    # Venv
    if [ "$2" == "py2" ] ; then
        virtualenv $VENV_DIR
    else
        pyvenv $VENV_DIR
    fi

    # Project dir
    mkdir $BASE_NAME/$APP_NAME
    pushd $BASE_NAME/$APP_NAME
    git init

    echo "alias $1='$ALIAS'" >> $PROJECT_ALIASES_PATH
    eval $ALIAS
}


function trb.enc.mount {
    encfs $HOME/Dropbox/.enc /home/marcin/enc
}


function trb.enc.umont {
    fusermount -u $HOME/enc
}
