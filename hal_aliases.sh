# Use vim as the default text exitor
export EDITOR=vim


# Set the default USERNAME so prompt is smaller on localhost
export DEFAULT_USER=$USER


alias ll='ls -lah'
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
alias lt='ls -alht -G'
alias ltr='ls -alhtr -G'
alias ls='ls -F -G'
alias ll='ls -al -G'

alias backup='cp \!* \!*`date "+.%Y.%m%d.%H%M"`'

alias g='grep -i'
alias ug='grep -i -v'
alias eg='egrep'
alias eug='egrep -v'
alias trim="sed 's/    */\t/g' \!*"

alias psg='ps -ef | grep \!* | grep -v grep | grep -v ps'
alias psug='ps -ef | grep -v \!* | grep -v grep | grep -v ps'
alias genmd5='find . -type f -exec md5sum \{\} \; > checksums.txt'
alias uuid="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]'  | pbcopy && pbpaste && echo"
alias utc='date -u "+%FT%TZ"'

# Git Shortcuts
alias gs='git status -uno'
alias ga='git add'
alias gb='git branch '
alias gc='git commit'
alias gd='git diff'
alias gt='git log --tags --simplify-by-decoration --pretty="format:%ai %d"'
alias gco='git checkout'
alias gk='gitk --all&'
alias gx='gitx --all'
alias gl='git log --oneline --decorate --graph'
alias gll='git log --stat --pretty=short --graph'
alias gla='git log --oneline --decorate --graph --all'
alias glla='git log --stat --pretty=short --graph --all'
alias git-delete-branches='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias git-branches='for branch in `git branch -r --merged | grep -v HEAD`; do echo -e `git show --format="%ci %cr %an" $branch | head -n 1` \\t$branch; done | sort -r'


# Prettier Cat using BAT https://github.com/sharkdp/bat
# brew install bat
alias cat='bat --style=changes'


# K8S Shortcuts
alias kbash="kubectl run dev-tools -i --tty --image=patrickglass/dev-tools --restart=Never --rm"
alias kexport="export KUBECONFIG=`pwd`/kubeconfig.yaml"
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# Shortcuts
alias proj='cd ~/proj/'
alias halplatform='cd ~/proj/halplatform'
alias patrickglass='cd ~/proj/patrickglass'


# Dockerized Tools
alias vault_docker='docker run -e http_proxy -e https_proxy -e no_proxy -e VAULT_ADDR -it --init vault sh'
alias ssllabs-scan='docker run -it jumanjiman/ssllabs-scan'


alias gh-pr-create='gh pr create --base main --assignee $USER --label "needs-review" --fill --draft'

# GPG Config
GPG_TTY=$(tty)
export GPG_TTY

# Uncomment to enable log output for terraform
# export TF_LOG_PATH=./terraform.log
