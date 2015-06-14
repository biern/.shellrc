_TRB_HDMI_CONFIG_FILE=$TRB_CONFIG_DIR/.setup-env.hdmi


function trb.init {
    if [ ! -d $TRB_CONFIG_DIR ] ; then
        mkdir -p $TRB_CONFIG_DIR
    fi
}


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
    ENV_FILE=`trb.project.env $1`

    if [ -e $ENV_FILE ] ; then
        source $ENV_FILE
    else
        echo "env file \"$ENV_FILE\" does not exist"
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


function trb.pulseaudio.change-sink {
    pacmd set-default-sink $1
    pacmd list-sink-inputs | grep index | while read line
    do
        pacmd move-sink-input `echo $line | cut -f2 -d' '` $1
    done
}


function trb.kmix.set-master {
    qdbus org.kde.kmix /Mixers org.kde.KMix.MixSet.setCurrentMaster $TRB_KMIX_OUTPUT $1
}


function trb.audio.use.analog {
    trb.pulseaudio.change-sink $TRB_PULSEAUDIO_SINK_ANALOG
    trb.kmix.set-master $TRB_KMIX_CONTROLS_ANALOG
}


function trb.audio.use.hdmi {
    trb.pulseaudio.change-sink $TRB_PULSEAUDIO_SINK_HDMI
    trb.kmix.set-master $TRB_KMIX_CONTROLS_HDMI
}


function trb.kmix.master_controls.toggle {
    current=`qdbus org.kde.kmix /Mixers org.kde.KMix.MixSet.currentMasterControl`

    if [[ $current == $TRB_KMIX_CONTROLS_HDMI ]] ; then
        trb.audio.use.analog
    else
        trb.audio.use.hdmi
    fi

    qdbus org.kde.kmix /Mixers org.kde.KMix.MixSet.currentMasterControl
}


function trb.setup-env.mixed-laptop-and-hdmi {
    xrandr --output $TRB_DISPLAY_LAPTOP --auto --primary --output $TRB_DISPLAY_HDMI --auto --right-of $TRB_DISPLAY_LAPTOP
    trb.audio.use.hdmi
    echo $TRB_SETUP_ENV_HDMI_MIXED > $_TRB_HDMI_CONFIG_FILE
}


function trb.setup-env.laptop-only {
    xrandr --output $TRB_DISPLAY_LAPTOP --auto --output $TRB_DISPLAY_HDMI --off
    trb.audio.use.analog
}


function trb.setup-env.hdmi-only {
    xrandr --output $TRB_DISPLAY_LAPTOP --off --output $TRB_DISPLAY_HDMI --auto
    trb.audio.use.hdmi
    echo $TRB_SETUP_ENV_HDMI_ONLY > $_TRB_HDMI_CONFIG_FILE
}


function trb.setup-env.autodetect {
    CONNECTED_OUTPUTS=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

    if [[ $CONNECTED_OUTPUTS =~ "${TRB_DISPLAY_HDMI}" ]] ; then
        if [ -e $_TRB_HDMI_CONFIG_FILE ] ; then
            HDMI_ENV=`cat $_TRB_HDMI_CONFIG_FILE`
        else
            HDMI_ENV=$TRB_SETUP_ENV_HDMI_DEFAULT
        fi

        if [[ $HDMI_ENV == $TRB_SETUP_ENV_HDMI_MIXED ]] ; then
            trb.setup-env.mixed-laptop-and-hdmi
            notify-send "Switching to mixed display"
        else
            trb.setup-env.hdmi-only
            notify-send "Switching to hdmi only"
        fi

    else
        trb.setup-env.laptop-only
        notify-send "Switching to laptop only"
    fi
}
