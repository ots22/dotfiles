shopt -s extglob 2> /dev/null
shopt -s histappend 2> /dev/null
shopt -s globstar 2> /dev/null
shopt -s autocd 2> /dev/null

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo -e ${PATH//:/\\n}'
alias l='ls'
alias ll='l -l'
alias la='l -a'
alias lla='ll -a'
alias chx='chmod u+x'
alias ssh='ssh -Y'
alias grep='grep --color=auto'
alias quiet='&>/dev/null'
alias q='quiet'

export BASH_SILENCE_DEPRECATION_WARNING=1

export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad
export PYTHONSTARTUP=~/.pystartup

export PATH=/opt/local/bin:$PATH:$HOME/bin:/Applications/j64-806/bin/
#export EDITOR=ecvisit

PS1='\[\e[1;36m\]\h:\w\$\[\e[0m\] '

[[ $PS1 && -f /etc/bash_completion ]] && . /etc/bash_completion

# For emacs remote directory tracking in ansi-term:
function emacs_term_dirtrack {
    printf "\eAnSiTu %s\n" "$LOGNAME"
    printf "\eAnSiTc %s\n" "$(pwd)"
    printf "\eAnSiTh %s\n" "$(hostname)"
}

export PROMPT_COMMAND="history -a"
if [ "$TERM" = "eterm-color" -a -n "$SSH_CONNECTION" ]; then
    export PROMPT_COMMAND="emacs_term_dirtrack; $PROMPT_COMMAND"
fi

export PATH=$PATH:/Users/ostrickson/bin:/Applications/Racket\ v7.8/bin
export PATH=/usr/local/opt/python/libexec/bin:/opt/local/lib/postgresql12/bin/:$PATH

source '/Users/ostrickson/lib/azure-cli/az.completion'

export POWERSHELL_TELEMETRY_OPTOUT=1
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
