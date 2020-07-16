# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# case sensitive completion
CASE_SENSITIVE="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

if [ -e $ZSH/oh-my-zsh.sh ]; then
  source $ZSH/oh-my-zsh.sh

# prompt
  NEWLINE=$'\n'
  PROMPT="[%{$fg_bold[green]%}%M%{$reset_color%}:%{$fg_bold[cyan]%}%~%{$reset_color%}]${NEWLINE}"
  PROMPT+="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
  PROMPT+=' $(git_prompt_info)'
else
  echo "zsh is not found in $ZSH/oh-my-zsh.sh"
fi

# User configuration

if (which go > /dev/null 2> /dev/null); then
  export GOROOT=/usr/local/opt/go/libexec
  export GOPATH=/Users/david/.go
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

alias l="ls"
alias ll="ls -lh"
alias sizeof="du -hd 0"
alias glggao='glgga --oneline'

if (which npm > /dev/null 2> /dev/null); then
  alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"
fi

#OS=$(uname -s)
#if [ $OS = "Linux" ]; then
#  alias __PROXY='HTTPS_PROXY=http://127.0.0.1:1080'
#elif [ $OS = "Darwin" ]; then
   alias __PROXY='HTTPS_PROXY=http://127.0.0.1:1087'
#fi

export LANG=en_US.UTF-8
export GPG_TTY=$(tty)
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
