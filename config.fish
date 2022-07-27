if status is-interactive
    # Commands to run in interactive sessions can go here
    alias l="ls"
    alias ll="ls -lh"
    alias sizeof="du -hd 0"
    alias glggao='glgga --oneline'
    alias ip="ip -color"
    alias iptables="iptables -n --line-numbers"
    alias ip6tables="ip6tables -n --line-numbers"

    alias rcp="rsync -avhW --no-compress --progress "

    alias pps='ps -o user,uid,pid,ppid,sid,args'
    alias ppsu='pps -u'

    alias c="clear"

    alias scst='sudo systemctl start'
    alias scsp='sudo systemctl stop'
    alias scrl='sudo systemctl reload'
    alias scrt='sudo systemctl restart'
    alias sce='sudo systemctl enable'
    alias scd='sudo systemctl disable'
    alias scs='systemctl status'
    alias scsw='systemctl show'
    alias sclu='systemctl list-units'
    alias scluf='systemctl list-unit-files'
    alias sclt='systemctl list-timers'
    alias scc='systemctl cat'
    alias scie='systemctl is-enabled'

    alias gst='git status '
    alias gco='git checkout '
    alias ga='git add '
    alias grs='git restore '
    alias grst='git restore --staged '
    alias gcb='gco -b '
    alias gbD='git branch -D '
    alias gp='git push '
    alias gl='git pull '
    alias gm='git merge '
    alias grb='git rebase '
    alias glgga='git log --graph --decorate --all '
    alias glggao='glgga --oneline '
    alias gr='git remote '
    alias gd='git diff '
    alias gc='git commit -v '

    export GPG_TTY=(tty)
    export EDITOR='vim'
    export PATH="$PATH:$HOME/.local/bin"
    export TERM=xterm-256color
end
