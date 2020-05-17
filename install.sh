#!/bin/bash
# set -e

mkdir -p "$HOME/.config"

case `uname` in
  Darwin)
    if ! which brew > /dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    PACKAGES="awscli git goenv htop ipython jq k9s n tfenv tgenv tmux zsh speedtest-cli wget"
    for PKG in $PACKAGES; do
      if ! brew list $PKG > /dev/null; then
        if [ "$PKG" = "tgenv" ]; then
          brew tap alextodicescu/tgenv
        fi

        brew install $PKG
      fi
    done

    ln -s "$DOTFILES_DIR/iTerm2" "$HOME/.config" 2>/dev/null

    if [[ ! -d "/Applications/iTerm.app" ]]; then
      echo "iTerm not found: https://www.iterm2.com/downloads.html"
      echo "Install it and load preferences from $HOME/.config/iTerm2"
    fi
  ;;

  Linux)
    PACKAGES="build-essential git curl zsh vim tmux xclip fonts-inconsolata speedtest-cli"
    if ! [ -x "$(command i3)" ]; then
      read -p "Install i3? [Y/n] " INSTALL_I3
      case $INSTALL_I3 in
        y|Y|"" )
          PACKAGES="$PACKAGES i3"
        ;;
      esac
    fi
    INSTALL_CMD="apt install --yes $PACKAGES"
    echo "Installing packages..."
    if sudo -v > /dev/null; then
      sudo $INSTALL_CMD
    else
      su -c $INSTALL_CMD
    fi
  ;;
esac

DOTFILES_DIR=$PWD
if [[ ! -d "$PWD/.git" ]]; then
  read -p "Path where the dotfiles repository should be cloned [$HOME/code/dotfiles]: " DOTFILES_DIR
  DOTFILES_DIR=${DOTFILES_DIR:-"$HOME/code/dotfiles"}
  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    mkdir -p "$DOTFILES_DIR"
    git clone https://github.com/tooxie/dotfiles.git "$DOTFILES_DIR"
  fi
fi


if [ "`uname`" = "Darwin" ]; then
  ln -s "$DOTFILES_DIR/iTerm2" "$HOME/.config" 2>/dev/null

  if [[ ! -d "/Applications/iTerm.app" ]]; then
    echo "iTerm not found: https://www.iterm2.com/downloads.html"
    echo "Install it and load preferences from $HOME/.config/iTerm2"
  fi
fi

CONF_FILES=".aliases .tmux.conf .vimrc"
for CONF in $CONF_FILES; do
  if [[ -f "$HOME/$CONF" ]]; then
    if [[ ! -L "$HOME/$CONF" ]]; then
      echo "$HOME/$CONF exists but it's not a symlink"
    fi
  else
    ln -s "$DOTFILES_DIR/$CONF" $HOME
  fi
done

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
OMZ_THEMES_DIR="custom/themes"
if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
  export CHSH='yes'
  export RUNZSH='no'
  export KEEP_ZSHRC='no'
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  rm -f "$OH_MY_ZSH_DIR/$OMZ_THEMES_DIR/example.zsh-theme"
  for THEME in `ls "$DOTFILES_DIR/.oh-my-zsh/$OMZ_THEMES_DIR"`; do
    ln -s "$DOTFILES_DIR/.oh-my-zsh/$OMZ_THEMES_DIR/$THEME" "$OH_MY_ZSH_DIR/$OMZ_THEMES_DIR"
  done
  rm -f "$HOME/.zshrc"
  ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if [[ ! -d "$VUNDLE_DIR" ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
  vim +PluginInstall +qall
fi

TMUX_PLUGINS_DIR="$HOME/.tmux/plugins"
TMUX_TPM_DIR="$TMUX_PLUGINS_DIR/tpm"
if [[ ! -d "$TMUX_TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm $TMUX_TPM_DIR
  TMUX_PLUGIN_MANAGER_PATH="$TMUX_PLUGINS_DIR" $TMUX_TPM_DIR/bin/install_plugins
fi

if [[ ! -f "$HOME/.gitconfig" ]]; then
  cp "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

  read -p "Git user full name: " GIT_NAME
  git config --global user.name "$GIT_NAME"

  read -p "Git user email: " GIT_EMAIL
  git config --global user.email $GIT_EMAIL
fi

if [[ ! -d "$HOME/.ssh" ]]; then
  ssh-keygen
  if which xclip > /dev/null; then
    cat $HOME/.ssh/id_rsa.pub | xclip -selection c -i
  else
    cat $HOME/.ssh/id_rsa.pub | pbcopy
  fi
  echo "* Key copied to clipboard"
  cat $HOME/.ssh/id_rsa.pub
  echo "Add your key to:"
  echo "  > Github: https://github.com/settings/ssh/new"
  echo "  > Gitlab: https://gitlab.com/profile/keys"
fi
