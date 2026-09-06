if status is-interactive
    # Commands to run in interactive sessions can go here
    alias k='kubectl '
    alias ka='k apply '
    alias kaf='ka -f '
    alias kd='k describe '
    alias kg='k get '
    alias l="ls"
    alias ll="ls -lh"
    alias sizeof="du -hd 0"

    alias rcp="rsync -avhW --no-compress --progress "

    alias pps='ps -o user,uid,pid,ppid,sid,args'
    alias ppsu='pps -u'

    alias c="clear"

    alias viam="vi -c 'vnew %.rej' "

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

    alias gs='git status '
    alias gso='git show '
    alias gsh='git stash '
    alias gco='git checkout '
    alias ga='git add '
    alias gap='git add -p '
    alias grs='git restore '
    alias grt='git reset '
    alias grsp='git restore -p '
    alias grst='git restore --staged '
    alias grstp='git restore --staged -p '
    alias gcb='gco -b '
    alias gbc='git branch | grep "*" | awk "{print \$2}"'
    alias gbD='git branch -D '
    alias gbd='git branch -d '
    alias gp='git push '
    alias gpc='gp -u origin (gbc)'
    alias gpu='git push -u '
    alias gl='git pull '
    alias gm='git merge '
    alias gmt='git mergetool --tool=vimdiff '
    alias gmff='git merge --ff-only'
    alias gmnff='git merge --no-ff '
    alias grb='git rebase '
    alias grba='grb --abort'
    alias grbc='grb --continue'
    alias grbi='grb -i '

    alias glg='git log --decorate '
    alias glgg='glg --graph '

    alias glga='glg --all '
    alias glgo='glg --oneline'
    alias glgao='glga --oneline '

    alias glgga='glgg --all '
    alias glggo='glgg --oneline'
    alias glggao='glgga --oneline '

    alias gr='git remote '
    alias gd='git diff '
    alias gdc='git diff --cached '
    alias gdh='git diff HEAD '
    alias gc='git commit -v -s '
    alias gcam='gc --amend '
    alias gam='git am '
    alias gamr='gam --reject '
    alias gama='gam --abort'
    alias gamc='gam --continue'

    alias gig='git grep '

    export GPG_TTY=(tty)
    export EDITOR='vim'
    export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH:$HOME/.local/bin:$HOME/.cargo/bin:/Users/david/.local/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-apple-darwin/bin"
    export TERM=xterm-256color
    export __GB_PROXY="http://127.0.0.1:8118"

    alias prun='ALL_PROXY="$__GB_PROXY" HTTP_PROXY="$__GB_PROXY" \
    HTTPS_PROXY="$__GB_PROXY" http_proxy="$__GB_PROXY" '

    # homebrew
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    end

    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

    # find
    function gfind
        if test (count $argv) -eq 0
            echo invalid arguments
            return 1
        else if test (count $argv) -eq 1
            set argv[2] '.'
        end

        find $argv[2..-1] -type file -exec grep -n --color=always  -H -i $argv[1] {} \; -exec echo '' \;
    end

    function glgv
        vim -c "silent r!git log --oneline --graph $argv" \
                -c 'set bt=nofile noma ft=git' \
                -c 'norm gg'
    end

    bind \ej down-or-search
    bind \ek up-or-search
end

set -x RUSTUP_UPDATE_ROOT https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
set -x RUSTUP_DIST_SERVER https://mirrors.tuna.tsinghua.edu.cn/rustup
