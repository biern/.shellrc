export WORDCHARS=${WORDCHARS//\//}
export WORDCHARS=${WORDCHARS//\./}
export LANG="en_US"
export LC_CTYPE="pl_PL.UTF-8"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/marcin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U colors && colors

insert_sudo () { zle beginning-of-line; zle -U "sudo "; }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo
