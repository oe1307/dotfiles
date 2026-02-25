#!/bin/zsh

# dotfiles
DOTFILES="$(dirname $0)"
ln -snvf "$DOTFILES/zshrc" "$HOME/.zshrc"
ln -snvf "$DOTFILES/bashrc" "$HOME/.bashrc"
ln -snvf "$DOTFILES/profile" "$HOME/.profile"
ln -snvf "$DOTFILES/hushlogin" "$HOME/.hushlogin"
mkdir -p "$HOME/.config"
for file in $(ls "$DOTFILES/config"); do
    ln -snvf "$DOTFILES/config/$file" "$HOME/.config/$file"
done
mkdir -p "$HOME/packages/share"
mkdir -p "$HOME/packages/bin"
for file in $(ls "$DOTFILES/packages/bin"); do
    ln -snvf "$DOTFILES/packages/bin/$file" "$HOME/packages/bin/$file"
done

# macOS settings
if [ "$(uname)" = "Darwin" ]; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.desktopservices DSDontWriteLocalStores true
    defaults write com.apple.desktopservices DSDontWriteUSBStores true
    defaults write -g com.apple.trackpad.scaling -int 3
    defaults write -g com.apple.sound.beep.volume -float 0.0
    defaults write com.apple.screencapture location -string $HOME/Downloads
    defaults write com.apple.LaunchServices LSQuarantine -bool false
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
    ln -snvf "$HOME/Library/CloudStorage/Box-Box/" "$HOME/Box"
fi

