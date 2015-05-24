function trb.venv_dir {
    echo "$PROJECTS_PATH/$1/venv-$1"
}


function trb.open_python_project {
    cd $PROJECTS_PATH/$1/$1
    source `trb.venv_dir $1`/bin/activate
}


function trb.create_python_project {
    VENV_DIR=`trb.venv_dir $1`
    ALIAS="trb.open_python_project $1"

    pushd $PROJECTS_PATH
    mkdir $1

    # Venv
    if [ "$2" == "py2" ] ; then
        virtualenv $VENV_DIR
    else
        pyvenv $VENV_DIR
    fi

    # Project dir
    mkdir $1/$1
    pushd $1/$1
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
