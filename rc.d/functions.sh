function trb.project.split_names {
    BASE_NAME=${1%/*}
    APP_NAME=${1#*/}

    if [ -z "$APP_NAME" ] ; then
        APP_NAME=BASE_NAME
    fi
}


function trb.project.venv_dir {
    trb.project.split_names $1

    echo "$PROJECTS_PATH/$BASE_NAME/venv-$APP_NAME"
}


function trb.project.env {
    trb.project.split_names $1

    echo "$PROJECTS_PATH/$BASE_NAME/.$APP_NAME.env"
}


function trb.project.open {
    trb.project.split_names $1

    PROJECT_DIR=$PROJECTS_PATH/$BASE_NAME/$APP_NAME

    if [ -e `trb.project.env $1` ] ; then
        source `trb.project.env $1`
    fi
}


function trb.project.create {
    trb.project.split_names $1
    ALIAS="trb.project.open $1"

    pushd $PROJECTS_PATH
    mkdir -p $BASE_NAME

    # Project dir
    mkdir -p $BASE_NAME/$APP_NAME
    pushd $BASE_NAME/$APP_NAME
    git init

    echo 'cd $PROJECT_DIR' >> `trb.project.env $1`

    echo "alias $1='$ALIAS'" >> $PROJECT_ALIASES_PATH
    eval $ALIAS
}


function trb.project.create.python {
    trb.project.create $1

    VENV_DIR=`trb.project.venv_dir $1`
    # Venv
    if [ -d $VENV_DIR ] ; then
        echo "virtualenv exists, skipping"
    else
        if [ "$2" == "py2" ] ; then
            virtualenv $VENV_DIR
        else
            pyvenv $VENV_DIR
        fi
    fi

    echo "source $VENV_DIR/bin/activate" >> `trb.project.env $1`

    trb.project.open $1
}


function trb.enc.mount {
    encfs $ENC_MOUNT_SRC $ENC_MOUNT_DST
    cd $ENC_MOUNT_DST
}


function trb.enc.umont {
    if [[ `pwd` == $ENC_MOUNT_DST* ]] ; then
        cd "${ENC_MOUNT_DST}/../"
    fi
    fusermount -u $ENC_MOUNT_DST
}
