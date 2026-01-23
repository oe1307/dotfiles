# dotfiles
mkdir -p "$HOME/.config"
for file in $(ls "$HOME/dotfiles/config"); do
    ln -snvf "$HOME/dotfiles/config/$file" "$HOME/.config/$file"
done
ln -snvf "$HOME/dotfiles/zshrc" "$HOME/.zshrc"
ln -snvf "$HOME/dotfiles/bashrc" "$HOME/.bashrc"
ln -snvf "$HOME/dotfiles/profile" "$HOME/.profile"
ln -snvf "$HOME/dotfiles/hushlogin" "$HOME/.hushlogin"

# accounts
mkdir -p "$HOME/.config/github-copilot"
ln -snvf "$HOME/.ssh/accounts/copilot.json" "$HOME/.config/github-copilot/apps.json"

if [ "$(uname)" = "Darwin" ]; then
    # macOS settings
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    defaults write com.apple.desktopservices DSDontWriteLocalStores true
    defaults write com.apple.desktopservices DSDontWriteUSBStores true
    defaults write -g com.apple.trackpad.scaling -int 3
    defaults write -g com.apple.sound.beep.volume -float 0.0
    defaults write com.apple.screencapture location -string /Users/issa/Downloads
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    defaults write com.apple.screencapture type -string "png"
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    defaults write -g KeyRepeat -int 2
    defaults write -g InitialKeyRepeat -int 15
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

    # cloud storage
    ln -snvf "$HOME/Library/CloudStorage/Box-Box/" "$HOME/Box"
fi

