if [ -d $HOME/.shellrc/zshrc.d ]; then
  for file in $HOME/.shellrc/zshrc.d/*.zsh; do
    source $file
  done
fi

if [ -d $HOME/.shellrc/rc.d ]; then
  for file in $HOME/.shellrc/rc.d/*.sh; do
    source $file
  done
fi
