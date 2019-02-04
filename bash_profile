export GOROOT=/usr/local/opt/go/libexec
export GOPATH=/Users/david/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GPG_TTY=$(tty)

alias l="ls -G"
alias ls="ls -lG"
alias ll="ls"
alias sizeof="du -h -d 0"

# Custom prompt
export PS1="\[\033[0;92m\]\u@\h\[\033[m\]:\[\033[0;94m\]\W\[\033[m\] $ "
