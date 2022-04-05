#!/bin/sh

if [ "$PREFIX" = "" ]; then
  PREFIX="$HOME"
fi

echo "deployment target 'PREFIX=$PREFIX'"

check_file() {
  if [ -f "$1" ]; then
    echo "test file $1 failed, exiting..."
    exit 1
  fi
}

check_dir() {
  if [ -d "$1" ]; then
      echo "test dir $1 failed, exiting..."
      exit 1
  fi
}

create_dir_if_not_exist() {
    if ! [ -d "$1" ]; then
        echo "directory $1 do not exist, creating..."
        if ! mkdir -p "$1"; then
            echo "cannot create directory: $1 , exiting..."
            exit 1
        fi
    fi
}

deploy_message() {
    if [ "$2" = "" ]; then
        echo "deploying $1"
    else
        echo "deploying $1 to $2"
    fi
}
deploy() {
    deploy_message "$1" "$2"
    if ! ln -s "$(pwd)/$1" "$2"; then
        echo "cannot deploy $1 to $2 , exiting..."
        exit 1
    fi
}
deploy_to_home() {
    if [ "$2" = "" ]; then
        deploy "$1" "$PREFIX/.$1"
    else
        deploy "$1" "$PREFIX/$2"
    fi
}
install() {
    deploy_to_home gitconfig
    deploy_to_home gitmessage

    deploy_to_home vimrc

    install_vundle

    deploy_to_home zshrc

    echo 'oh-my-zsh is recommended. To install, run ./install.sh oh-my-zsh'

    echo "[recommended] install package: xorg i3 pulseaudio fcitx feh termite"

    echo "fin"
    exit
}

install_i3_config() {
    create_dir_if_not_exist "$PREFIX/.config/i3"
    deploy i3-config "$PREFIX/.config/i3/config"
}

install_vundle() {
    echo "installing vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git "$PREFIX/.vim/bundle/vundle"
    deploy vundle.vimrc "$PREFIX/.vim/vundlerc"
}

__dp_rime () {
    if [ "$(uname -s)" = "Linux" ]; then
        deploy "rime/$1" "$PREFIX/.local/share/fcitx5/rime/$1"
    elif [ "$(uname -s)" = "Darwin" ]; then
        deploy "rime/$1" "$PREFIX/Library/Rime/$1"
    fi
}

install_rime_skin() {
    echo "installing fcitx5 themes"
    cd "$PREFIX/.local/share/fcitx5/themes" || { echo "$PREFIX/.local/share/fcitx5/themes does not exist" && exit 1; }
    git clone https://github.com/sxqsfun/fcitx5-sogou-themes.git
    mv fcitx5-sogou-themes/Alpha-white .
}

install_rime() {
    echo "installing rime"
    __dp_rime default.custom.yaml
    __dp_rime squirrel.custom.yaml
    __dp_rime wubi86_jidian.dict.yaml
    __dp_rime wubi86_jidian_user.dict.yaml
    __dp_rime wubi86_jidian.schema.yaml
    __dp_rime wubi86_jidian.txt
    if [ "$(uname -s)" = "Linux" ]; then
        install_rime_skin
    fi
}

install_oh_my_zsh() {
    echo "installing oh-my-zsh over internet"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

show_help() {
cat 1>&2 <<EOF
Usage: sh install.sh [target]
    OR sh install.sh all
    OR sh install.sh i3-config
    OR sh install.sh vundle
    OR sh install.sh rime
    OR sh install.sh oh-my-zsh
    OR sh install.sh alacritty
    OR sh install.sh help

    sh install [target]

        install [target] to \$PREFIX/.[target]

    sh install all

        install gitconfig gitmessage vimrc vundle and zshrc
EOF
}

case "$1" in
    i3-config)
        install_i3_config
        exit
        ;;
    vundle)
        install_vundle
        exit
        ;;
    rime)
        install_rime
        exit
        ;;
    oh-my-zsh)
        install_oh_my_zsh
        exit
        ;;
    alacritty)
        _DEPLOY_TARGET="$PREFIX/.config/alacritty/alacritty.yml"
        check_file "$_DEPLOY_TARGET"
        create_dir_if_not_exist "$PREFIX/.config/alacritty"
        deploy alacritty "$_DEPLOY_TARGET"
        exit
        ;;
    '')
        show_help
        exit
        ;;
    help)
        show_help
        exit
        ;;
    all)
        install
        exit
        ;;
    *)
        check_file "$PREFIX/.$1"
        deploy_to_home "$1"
        echo "fin"
        ;;
esac
