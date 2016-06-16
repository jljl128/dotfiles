hg_prompt() {
    hg root >& /dev/null
    if [ $? == 0 ];then
        echo "[$(hg branch)]"
    fi
}

PS1='\e[0;33m\w $(hg_prompt)\n\$ \e[m'

export LC_CTYPE=C
export LANG=C
export LC_ALL=en_US.UTF-8

[ -s "~/.dnx/dnvm/dnvm.sh" ] && . "~/.dnx/dnvm/dnvm.sh" # Load dnvm

alias ll="ls -alF"

