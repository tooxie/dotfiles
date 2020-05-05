#!/bin/bash
mkdir -p "$HOME/.config"

case `uname` in
  Darwin)
    if ! which brew > /dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    PACKAGES="awscli git goenv htop ipython jq k9s n tfenv tgenv tmux zsh"
    for PKG in $PACKAGES; do
      if ! brew list $PKG > /dev/null; then
        if [ "$PKG" = "tgenv" ]; then
          brew tap alextodicescu/tgenv
        fi

        brew install $PKG
      fi
    done

    ln -s "$PWD/iTerm2" "$HOME/.config" 2>/dev/null

    if [[ ! -d "/Applications/iTerm.app" ]]; then
      echo "iTerm not found: https://www.iterm2.com/downloads.html"
      echo "Install it and load preferences from $HOME/.config/iTerm2"
    fi
  ;;

  Linux)
    PACKAGES="build-essentials git"
    if sudo -v > /dev/null; then
      sudo -s
    else
      su -
    fi

    sudo apt install $PACKAGES
  ;;
esac

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ln -s "$PWD/.oh-my-zsh/custom/themes/*" "$OH_MY_ZSH_DIR/custom/themes"
fi

VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if [[ ! -d "$VUNDLE_DIR" ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
  vim +PluginInstall +qall
fi

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  git clone https://github.com/tmux-plugins/tpm $TPM_DIR
  $TPM_DIR/bin/install_plugins
fi

CONF_FILES=".aliases .tmux.conf .vimrc .zshrc"
for CONF in $CONF_FILES; do
  if [[ -f "$HOME/$CONF" ]]; then
    if [[ ! -L "$HOME/$CONF" ]]; then
      echo "$HOME/$CONF exists but it's not a symlink"
    fi
  else
    ln -s "$PWD/$CONF" $HOME
  fi
done
