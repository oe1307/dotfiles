#!/bin/sh

# Copy regular files interactively without following destination symlinks.
copy_config() (
    src=$1
    dst=$2

    if [ -L "$dst" ]; then
        printf 'Skipping existing symbolic link: %s\n' "$dst" >&2
    elif [ -L "$src" ]; then
        printf 'Skipping source symbolic link: %s\n' "$src" >&2
    elif [ -d "$src" ]; then
        mkdir -p "$dst" || exit 1
        for entry in "$src"/* "$src"/.[!.]* "$src"/..?*; do
            [ -e "$entry" ] || [ -L "$entry" ] || continue
            copy_config "$entry" "$dst/${entry##*/}"
        done
    elif [ -e "$dst" ] && [ ! -f "$dst" ]; then
        printf 'Skipping non-regular destination: %s\n' "$dst" >&2
    else
        cp -i "$src" "$dst"
    fi
)

# dotfiles
copy_config "$HOME/dotfiles/shell/zshrc" "$HOME/.zshrc"
copy_config "$HOME/dotfiles/shell/bashrc" "$HOME/.bashrc"
copy_config "$HOME/dotfiles/shell/profile" "$HOME/.profile"
copy_config "$HOME/dotfiles/shell/hushlogin" "$HOME/.hushlogin"
copy_config "$HOME/dotfiles/config" "$HOME/.config"

# Keep actual aliases as symbolic links, but never replace them silently.
link_config() {
    if [ -d "$2" ] && [ ! -L "$2" ]; then
        printf 'Skipping existing directory: %s\n' "$2" >&2
    else
        ln -snvi "$1" "$2"
    fi
}

# macOS settings
if [ "$(uname)" = "Darwin" ]; then
    chmod -R go-w /opt/homebrew/share
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.desktopservices DSDontWriteLocalStores true
    defaults write com.apple.desktopservices DSDontWriteUSBStores true
    defaults write -g com.apple.trackpad.scaling -int 3
    defaults write -g com.apple.sound.beep.volume -float 0.0
    defaults write com.apple.screencapture location -string $HOME/Downloads
    defaults write com.apple.screencapture type -string "png"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15
    defaults write com.apple.dock tilesize -int 16
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.screencapture show-thumbnail -bool false
    defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
    defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
    defaults write com.microsoft.Powerpoint NSUserKeyEquivalents -dict-add "数式" "^e"
    defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
    defaults write com.apple.dock orientation -string left
    sudo nvram BootPreference=%00
    brew autoupdate start 12h --upgrade --cleanup --immediate --sudo 2>/dev/null
    link_config "$HOME/Library/CloudStorage/Box-Box/" "$HOME/Box"
    link_config "/opt/zerobrew/bin/podman" "/opt/zerobrew/bin/docker"
fi
