export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/david/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GPG_TTY=$(tty)

alias l="ls"
alias ls="ls -lhG"
alias ll="ls"
alias sizeof="du -h -d 0"

# Custom prompt
export PS1="\[\033[0;92;1m\]\u@\h\[\033[m\]:\[\033[0;94m\]\W\[\033[m\] $ "

# The fuck
eval $(thefuck --alias)
