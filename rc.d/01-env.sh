# export PATH=$PATH:~/bin
export PATH="/usr/local/heroku/bin:$PATH"
export EDITOR=startemacs

# source `which virtualenvwrapper.sh`
export PIP_RESPECT_VIRTUALENV=true # Tell pip to automatically use the currently active virtualenv.
# venvwrapper
export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
source /usr/bin/virtualenvwrapper.sh

if [ -e ~/.nvm/nvm.sh ] ; then
    source ~/.nvm/nvm.sh
fi


export PROJECTS_PATH="$HOME/projekty"
export PROJECT_ALIASES_PATH="$HOME/.shellrc/rc.d/project_aliases.sh"
