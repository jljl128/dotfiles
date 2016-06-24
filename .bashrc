alias ll="ls -alF"
alias mvim="open -a MacVim"

# Use VI mode
set -o vi

# Git things - got .gitcompletion.bash from:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
test -f ~/.git-completion.bash && . $_
test -f ~/.git-prompt.sh && . $_
export GIT_PS1_SHOWDIRTYSTATE=true

test -f ~/.docker-completion.sh && . $_
test -f ~/.docker-machine-completion.sh && . $_
test -r ~/.docker-compose-completion.sh && . $_

# Mercurial things
hg_prompt() {
    hg root >& /dev/null
    if [ $? == 0 ];then
        echo " ($(hg branch))"
    fi
}

PS1='\e[0;33m\w$(hg_prompt)$(__git_ps1)\e[m\n\$ '

export LC_CTYPE=C
export LANG=C
export LC_ALL=en_US.UTF-8

test -f ~/.dnx/dnvm/dnvm.sh && . $_
