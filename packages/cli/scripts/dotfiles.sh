#!/bin/sh 
 
set -e 

GIT_CLONE_PATH=~/src/github.com/edm20627
STOW_PACKAGES_PATH="$GIT_CLONE_PATH"/dotfiles/packages

unlink_packages=
verbose=
for i in "$@"; do
    case "$i" in
        -s|--skip-apps)
            skip_apps=1
            shift ;;
        -v|--verbose)
            verbose=1
            shift ;;
        -u=*|--unlink=*)
            unlink_packages="${i#*=}"
            shift ;;
        *) ;;
    esac
done

log() {
    message=$1
    echo 📌 "$message"
}

is_file() {
    path="$1"
    [ -f "$path" ]
}

is_dir() {
    path="$1"
    [ -d "$path" ]
}

ensure_dir() {
    path="$1"
    if ! is_dir "$path"; then
        mkdir -p "$path"
    fi
}

if [ -n "$unlink_packages" ]; then
    log 'Unlinking dotfiles...'
    stow -vD -d "$STOW_PACKAGES_PATH" -t ~ "$unlink_packages"
    exit
fi
 
if [ "$(dscl . -read ~/ UserShell)" = "UserShell: /bin/bash" ]; then 
    log 'Change default shell to zsh'
    chsh -s /bin/zsh
    chmod -R 755 /usr/local/share/zsh
    chown -R root:staff zsh
fi 

if ! is_file /usr/local/bin/brew; then
    log 'Setup Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

ensure_dir "$GIT_CLONE_PATH"

if ! is_dir "$GIT_CLONE_PATH"/dotfiles; then
    log 'Clone dotfiles'
    cd "$GIT_CLONE_PATH"
    git clone git@github.com:edm20627/dotfiles.git
fi

if [ ! "$skip_apps" ]; then
    log 'Install Apps and CLIs'
    brew bundle --file "$GIT_CLONE_PATH"/dotfiles/Brewfile $([ -n "$verbose" ] && echo -v)
fi

log 'Link dotfiles'
ensure_dir ~/.config/alacritty

# shellcheck disable=SC2046
stow -vd "$STOW_PACKAGES_PATH" -t ~ $(ls $STOW_PACKAGES_PATH)

### asdf Install Script
for plugin in $(awk '{print $1}' ~/.tool-versions); do
    if ! is_dir ~/.asdf/plugins/"$plugin"; then
        asdf plugin add "$plugin"
    fi
done

is_runtime_versions_changed () {
    plugin="$1"
    specified=$(grep "$plugin" ~/.tool-versions | awk '{$1=""; print $0}')
    installed=$(asdf list "$plugin" 2>&1)

    is_changed=
    for version in $specified; do
        match=$(echo "$installed" | grep "$version")
        [ -z "$match" ] && is_changed=1
    done

    [ "$is_changed" ]
}

for plugin in $(asdf plugin list); do
    if is_runtime_versions_changed "$plugin"; then
        if [ "$plugin" = nodejs ]; then log "Import release team keyring for Node.JS"
            bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
        fi

        log "Install runtime: $plugin"
        asdf install "$plugin"
    fi
done

sudo chmod -R a+wr /usr/local/bin

# plug_path=~/.local/share/nvim/site/autoload/plug.vim
# if ! is_file "$plug_path"; then
#     log 'Setup vim-plug"'
#     sh -c "curl -fLo $plug_path --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# fi

dein_cache_path=~/.cache/dein
if ! is_dir "$dein_cache_path"; then
    log 'Setup dein.vim"'
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
    sh ./installer.sh ~/.cache/dein  
    rm installer.sh
fi

# if ! is_dir /Library/ScriptingAdditions/yabai.osax; then
#     log 'Setup yabai'
#     sudo yabai --install-sa
# fi

# limelight_path=/usr/local/bin/limelight
# if ! is_file "$limelight_path"; then
#     git clone https://github.com/koekeishiya/limelight
#     cd limelight
#     make
#     mv ./bin/limelight /usr/local/bin/limelight
#     cd ../
#     rm -rf limelight
# fi

# if ! is_dir ~/.hammerspoon; then
#     mkdir ~/.hammerspoon
# fi

# if ! is_dir ~/.hammerspoon/stackline; then
#     git clone https://github.com/AdamWagner/stackline.git ~/.hammerspoon/stackline
#     (
#         cd ~/.hammerspoon
#         echo 'stackline = require "stackline.stackline.stackline"' >> init.lua
#         echo 'stackline:init()' >> init.lua
#     )
# fi
