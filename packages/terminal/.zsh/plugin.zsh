# shellcheck disable=SC2034
source /usr/local/opt/zplug/init.zsh

# zsh-completions
# fpath=(~/.zplug/repos/zsh-users/zsh-completions/src ~/.zsh/completion "${fpath[@]}")
# fpath=(/usr/local/opt/zplug/repos/zsh-users/zsh-completions $fpath)


# zplug
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-autosuggestions"
zplug "romkatv/powerlevel10k", use:powerlevel10k.zsh-theme
zplug load
setopt nonomatch
if [[ ${#ZSH_HIGHLIGHT_STYLES[@]} -ne 0 ]]; then
    export ZSH_HIGHLIGHT_STYLES['path']='fg=081'
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enhancd
export ENHANCD_FILTER=peco
export ENHANCD_DISABLE_DOT=1
export ENHANCD_DISABLE_HOME=1
