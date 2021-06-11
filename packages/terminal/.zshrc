export PATH=$PATH:$HOME/scripts
export GIT_CLONE_PATH="$HOME"/src/github.com/edm20627

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
# 補完候補にもシンタックスハイライトが反映される設定
# colors関数を読み込んで、実行する
autoload -Uz colors && colors
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

# sub files {{{
# alias
source ~/.zsh/alias.zsh
# completion
# source ~/.zsh/completion.zsh
# peco
source ~/.zsh/search.zsh
# local setting
if [[ -e ~/.zshrc_local ]]; then
    source ~/.zshrc_local
fi
# }}}
