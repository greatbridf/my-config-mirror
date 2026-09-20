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
deploy_fish_config() {
    _DEPLOY_TARGET="$PREFIX/.config/fish/config.fish"
    check_file "$_DEPLOY_TARGET"
    create_dir_if_not_exist "$PREFIX/.config/fish"
    deploy config.fish "$_DEPLOY_TARGET"
}
install() {
    deploy_to_home gitconfig
    deploy_to_home gitmessage

    deploy_to_home vimrc
    deploy_to_home tmux.conf

    install_vimplug
    install_nvimplug

    deploy_fish_config

    echo "[recommended] install package: xorg i3 pulseaudio fcitx feh termite"

    echo "fin"
    exit
}

install_i3_config() {
    create_dir_if_not_exist "$PREFIX/.config/i3"
    deploy i3-config "$PREFIX/.config/i3/config"
}

install_vimplug() {
    echo "installing vimplug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_nvimplug() {
    echo "installing vim-plug for nvim"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
    OR sh install.sh vimplug
    OR sh install.sh rime
    OR sh install.sh oh-my-zsh
    OR sh install.sh alacritty
    OR sh install.sh config.fish
    OR sh install.sh help

    sh install [target]

        install [target] to \$PREFIX/.[target]

    sh install all

        install gitconfig gitmessage vimrc vimplug and config.fish
EOF
}

fatal() {
	echo "fatal: $1" >&2
	exit 1
}

info() {
	echo "info: $1" >&2
}

check_exists() {
	if [ -e "$1" ]; then
		return
	fi

	return 1
}

new_deploy() {
	local config config_name target target_dir
	[ $# -ge 1 ] && config="$(realpath "$1")" || fatal "invalid argument to new_deploy"
	config_name="$(basename "$config")"

	[ $# -ge 2 ] && target="$2" || target="$HOME/.$config_name"
	target_dir="$(dirname "$target")"

	if check_exists "$target"; then
		local backup_target="$target_dir/$config_name.old"
		info "$target exists, backing up to $backup_target"
		mv "$target" "$backup_target"
	fi

	info "deploying $config to $target"
	ln -s "$config" "$target"
}

new_all() {
	new_deploy gitconfig
	new_deploy gitmessage

	new_deploy vimrc
	new_deploy tmux.conf
	new_deploy config.fish "$HOME/.config/fish/config.fish"

	install_vimplug
}

case "$1" in
    i3-config)
        install_i3_config
        exit
        ;;
    vimplug)
        install_vimplug
        exit
        ;;
    nvimplug)
        install_nvimplug
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
    config.fish)
        deploy_fish_config
        ;;
    '')
        show_help
        exit
        ;;
    help)
        show_help
        exit
        ;;
    enable-click-and-drag)
        if test `uname -s` != "Darwin"; then
            echo "This operation could only be done under macOS."
            exit 1
        fi
        defaults write -g NSWindowShouldDragOnGesture -bool true
        exit
        ;;
    disable-key-repeating)
        if test `uname -s` != "Darwin"; then
            echo "This operation could only be done under macOS."
            exit 1
        fi
        defaults write -g ApplePressAndHoldEnabled -bool false
        exit
        ;;
    all)
        install
        exit
        ;;
    new-all)
	    new_all
	    exit
	    ;;
    *)
        check_file "$PREFIX/.$1"
        deploy_to_home "$1"
        echo "fin"
        ;;
esac
