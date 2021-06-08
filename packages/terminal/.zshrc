export PATH=$PATH:$HOME/scripts
export GIT_CLONE_PATH="$HOME"/src/github.com/edm20627

alias cat="bat"
alias ls="exa"
alias ll="ls -lah --git"
alias lt="ll -TL 3 --ignore-glob=.git"
alias cdrepo=". cdrepo"
alias lscmd="ls ~/scripts"
alias pr="gh pr view --web"
alias vi="nvim"

. /usr/local/opt/asdf/asdf.sh

eval "$(starship init zsh)"
# eval "$(zoxide init zsh)"

# export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND="rg --files --hidden -l -g '!.git/*' -g '!node_modules/*'"
export FZF_DEFAULT_OPTS="-m --height 100% --border --preview 'cat {}'"

. $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^e' autosuggest-accept
