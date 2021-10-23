alias rm='rm -I'

# Git Shortcuts
alias gs='git status '
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
#alias go='git checkout '
alias gk='gitk --all&'
alias gx='gitx --all'
alias gl="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias gpp='git pull; git push'

# Custom Aliases
alias df='df -h'
alias ps='ps -aef'
alias h='history'
alias hh='history | less'
alias gvim='gvim -reverse -fn fixed'
alias bdiff='bcompare'
alias cpu='cat /proc/cpuinfo ; cat /proc/meminfo ; lspci'
alias u='cd ../'
alias uu='cd ../../'
alias uuu='cd ../../../'
alias l='less'
alias lt='ls -alht --color=auto'
alias ltr='ls -alhtr --color=auto'
alias ls='ls -Fh --color=auto'
alias ll='ls -alhF --color=auto'
alias cd='set old=$cwd; cd'
alias backup='cp \!* \!*`date "+.%Y.%m%d.%H%M"`'
alias g='grep -i'
alias ug='grep -i -v'
alias eg='egrep'
alias eug='egrep -v'
alias trim="sed 's/    */\t/g' \!*"
alias psg='ps -ef | grep \!* | grep -v grep | grep -v ps'
alias psug='ps -ef | grep -v \!* | grep -v grep | grep -v ps'
alias so='source'
alias yum='sudo yum'
alias tee='tree -A -S'
alias genmd5='find . -type f -exec md5sum \{\} \; > checksums.txt'

alias rsync='rsync -av --progress'

fn() { find . -name "*$@*"; }
