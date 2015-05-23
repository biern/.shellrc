PROJECTS_PATH="$HOME/projekty"
ALIASES_PATH="$HOME/.shellrc/rc.d/aliases.sh"


function trb.create_python_project {
    VENV_DIR="$PROJECTS_PATH/$1/venv-$1"
    ALIAS="cd $PROJECTS_PATH/$1/$1 && source $VENV_DIR/bin/activate"

    pushd $PROJECTS_PATH
    mkdir $1

    # Venv
    if [ "$2" == "py3" ] ; then
        pyvenv $VENV_DIR
    else
        virtualenv $VENV_DIR
    fi

    # Project dir
    mkdir $1/$1
    pushd $1/$1
    git init

    echo "alias $1='$ALIAS'" >> $ALIASES_PATH
    eval $ALIAS
}
