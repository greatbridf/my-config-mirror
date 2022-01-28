#!/bin/sh

if [ $__PREFIX ]; then
  __HOME=$__PREFIX
fi
if [ ! $__HOME ]; then
    __HOME=$HOME
fi
echo "deployment target 'HOME=$__HOME'"
__DIRS=(
       "$__HOME/.vim"
       "$__HOME/.vim/bundle/vundle"
       "$__HOME/.oh-my-zsh"
       )
__FILES=(
        "$__HOME/.bash_profile"
        "$__HOME/.gitconfig"
        "$__HOME/.gitmessage"
        "$__HOME/.vimrc"
        "$__HOME/.vim/vundlerc"
        "$__HOME/.zshrc"
        "$__HOME/.xinitrc"
        "$__HOME/.config/i3/config"
        )

check_file() {
  if [ -f $1 ]; then
    echo "test file $1 failed, exiting..."
    exit
  fi
}

check_dir() {
  if [ -d $1 ]; then
      echo "test dir $1 failed, exiting..."
      exit
  fi
}

check_file_existance() {
    for dir in "${__DIRS[@]}"; do
      check_dir $dir
    done

    for file in "${__FILES[@]}"; do
      check_file $file
    done
}

create_dir_if_not_exist() {
    if [ ! -d $1 ]; then
        echo "directory $1 do not exist, creating..."
        if ! mkdir -p $1; then
            echo "cannot create directory: $1 , exiting..."
            exit 1
        fi
    fi
}

message() {
    if [ $2 ]; then
        echo "deploying $1 to $2"
    else
        echo "deploying $1"
    fi
}
deploy() {
    message $1 $2
    if ! ln -s $(pwd)/$1 $2; then
        echo "cannot deploy $1 to $2 , exiting..."
    fi
}
deploy_to_home() {
    if [ $2 ]; then
        deploy $1 $__HOME/$2
    else
        deploy $1 $__HOME/.$1
    fi
}
confirm() {
    read -p "$1 (y/N) " __FLAG
    if [ $__FLAG != "y" ]; then
        exit
    fi
}
install() {
    confirm "start deployment?"

    deploy_to_home bash_profile
    deploy_to_home gitconfig
    deploy_to_home gitmessage

    deploy_to_home vimrc

    install_vundle

    deploy_to_home zshrc
    echo "run the command below to install oh-my-zsh"
    echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

    echo "[recommended] install package: xorg i3 pulseaudio fcitx feh termite"
    deploy_to_home xinitrc

    install_i3_config

    echo "fin"
    exit
}

install_i3_config() {
    create_dir_if_not_exist $HOME/.config/i3
    deploy i3-config $HOME/.config/i3/config
}

install_vundle() {
    echo "installing vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git $__HOME/.vim/bundle/vundle
    deploy vundle.vimrc $__HOME/.vim/vundlerc
}

__dp_rime () {
    deploy rime/$1 $HOME/Library/Rime/$1
}

install_rime() {
    echo "installing rime"
    __dp_rime default.custom.yaml
    __dp_rime squirrel.custom.yaml
    __dp_rime wubi86_jidian.dict.yaml
    __dp_rime wubi86_jidian_user.dict.yaml
    __dp_rime wubi86_jidian.schema.yaml
    __dp_rime wubi86_jidian.txt
}

if [ $1 = "i3-config" ]; then
    install_i3_config
    exit
fi

if [ $1 = "vundle" ]; then
    install_vundle
    exit
fi

if [ $1 = "rime" ]; then
    install_rime
    exit
fi

if [ $1 ]; then
  check_file $__HOME/.$1
  deploy_to_home $1
  echo "fin"
else
  check_file_existance
  install
fi
