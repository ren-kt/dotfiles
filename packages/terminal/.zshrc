# inport plugin {{{
source ~/.zsh/plugin.zsh
# }}}

# history {{{
# 保存数を増やす
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=1000000
# コマンドが入力されるとすぐに追加
setopt inc_append_history
# 同時に起動しているzshの間でhistoryを共有する
setopt share_history
# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups
# }}}

# cdr {{{
# 開いたディレクトリの履歴からディレクトリを開く
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-max 1000
zstyle ':chpwd:*' recent-dirs-file ~/.cache/chpwd-recent-dirs
# }}}


# color {{{
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# 補完候補にもシンタックスハイライトが反映される設定
# verboseスタイルにyes
zstyle ':completion:*' verbose yes
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# }}}

# option {{{
# ファイル種別の記号を補完候補の末尾から非表示
unsetopt list_types
# ビープ音の停止
setopt no_beep
# ビープ音の停止(補完時)
setopt nolistbeep
# 環境変数を補完
setopt AUTO_PARAM_KEYS
# }}}

# FUNCTION {{{
function pr-open {
    local url
    url=$(hub pr list -h "$(git symbolic-ref --short HEAD)" -f "%U")
    if [[ -z $url ]]; then
        echo "The PR based this branch not found."
        return 1
    fi
    open "$url"
}
# }}}

# asdf
if [[ -f $(brew --prefix asdf)/asdf.sh ]]; then
    . $(brew --prefix asdf)/asdf.sh
fi
# }}}

# starship {{{
eval "$(starship init zsh)"
# }}}

# zoxide {{{
# eval "$(zoxide init zsh)"
# }}}

# FZF {{{
# export FZF_DEFAULT_COMMAND="rg --files --hidden -l -g '!.git/*' -g '!node_modules/*'"
# export FZF_DEFAULT_OPTS="-m --height 100% --border --preview 'cat {}'"
# if [[ -f ~/.fzf.zsh ]]; then
#     source ~/.fzf.zsh
# fi
# }}}

# OTHER {{{
export PATH=$PATH:$HOME/scripts

export GIT_CLONE_PATH="$HOME"/src/github.com/edm20627

# golang
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# tmux
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git

precmd () {
    LANG=en_US.UTF-8 vcs_info
    # shellcheck disable=SC2154
    if [[ -z ${vcs_info_msg_0_} ]] || [[ -e .git ]]; then
        tmux rename-window "$(basename "$(pwd)")"
    fi
}
# }}}

# sub files {{{
# alias
source ~/.zsh/alias.zsh
# completion
source ~/.zsh/completion.zsh
# peco
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
# }}}
