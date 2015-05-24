.shellrc
********

Shell configuration based on http://chr4.org/blog/2014/09/10/conf-dot-d-like-directories-for-zsh-slash-bash-dotfiles/ . Adds ``trb.*`` namespace for various utility functions.

Installation
============

zsh::

  cd ~
  git clone https://github.com/biern/.shellrc.git
  cp ~/.zshrc ~/.zshrc.bkp
  cp ~/.shellrc/examples.d/.zshrc ~/.zshrc


Features
========

* Features are contained in ``trb.*`` namespace. Required environment variables are defined in `01-env.sh`_.
* Installs `oh-my-zsh`_ when used along with zsh.

..

    _`01-env.sh`: rc.d/01-env.sh
    _`oh-my-zsh`: https://github.com/robbyrussell/oh-my-zsh


Managing projects with trb.project:
-----------------------------------

Note that $APP_NAME always defaults to $NAME, so ``trb.open_project test`` and ``trb.project.open test/test`` are equal.

* ``trb.project.create.python NAME[/APP_NAME]``

  Creates new python project at ``$PROJECTS_PATH/$NAME/$APP_NAME``. Generates python virtualenv at ``$PROJECTS_PATH/$NAME/venv-$APP_NAME`` and ``$PROJECTS_PATH/$NAME/.$APP_NAME.env`` file that activates that virtualenv. Generates ``NAME[/APP_NAME]`` alias in ``.shellrc/rc.d/project_aliases.sh``.

  Note that ``trb.project.create.python`` can be used to generate .env files in existing projects, so that ``trb.project.open`` can open them.

* ``trb.project.open NAME[/APP_NAME]``

  Open project at ``$PROJECTS_PATH/$NAME/$APP_NAME`` by sourcing ``$PROJECTS_PATH/$NAME/.$APP_NAME.env``. ``$PROJECT_DIR`` is available in context.


See `functions.sh`_ for full reference.

.. _`functions.sh`: rc.d/functions.sh
