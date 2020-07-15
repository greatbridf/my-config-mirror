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
       )
__FILES=(
        "$__HOME/.bash_profile"
        "$__HOME/.gitconfig"
        "$__HOME/.gitmessage"
        "$__HOME/.vimrc"
        "$__HOME/.vim/vundlerc"
        )

check_file_existance() {
    for dir in "${__DIRS[@]}"; do
        if [ -d $dir ]; then
            echo "test dir $dir failed, exiting..."
            exit
        fi
    done

    for file in "${__FILES[@]}"; do
        if [ -f $file ]; then
            echo "test file $file failed, exiting..."
            exit
        fi
    done
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
    ln -s $(pwd)/$1 $2
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
    echo "installing vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git $__HOME/.vim/bundle/vundle
    deploy vundle.vimrc $__HOME/.vim/vundlerc

    echo "fin"
    exit
}
check_file_existance
install
