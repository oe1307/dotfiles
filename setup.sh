#!/bin/sh

copy_config() (
    src=$1
    dst=$2

    if [ ! -e "$src" ] && [ ! -L "$src" ]; then
        printf 'Missing source: %s\n' "$src" >&2
        exit 1
    elif [ -L "$dst" ]; then
        printf 'Skipping existing symbolic link: %s\n' "$dst" >&2
    elif [ -L "$src" ]; then
        printf 'Skipping source symbolic link: %s\n' "$src" >&2
    elif [ -d "$src" ]; then
        mkdir -p "$dst" || { printf 'Cannot create directory: %s\n' "$dst" >&2; exit 1; }
        failed=0
        for entry in "$src"/* "$src"/.[!.]* "$src"/..?*; do
            [ -e "$entry" ] || [ -L "$entry" ] || continue
            copy_config "$entry" "$dst/${entry##*/}" || failed=1
        done
        exit "$failed"
    elif [ -e "$dst" ] && [ ! -f "$dst" ]; then
        printf 'Skipping non-regular destination: %s\n' "$dst" >&2
    else
        cp -i "$src" "$dst" || { printf 'Cannot copy: %s -> %s\n' "$src" "$dst" >&2; exit 1; }
    fi
)
link_config() {
    if [ -d "$2" ] && [ ! -L "$2" ]; then
        printf 'Skipping existing directory: %s\n' "$2" >&2
    else
        ln -snvi "$1" "$2"
    fi
}

required_failures=0
optional_failures=0
failures=

run_step() {
    step_kind=$1
    shift
    if "$@"; then
        return 0
    else
        step_status=$?
    fi
    failures="${failures}
  $step_kind (exit $step_status): $*"
    case "$step_kind" in
        ERROR) required_failures=$((required_failures + 1)) ;;
        WARNING) optional_failures=$((optional_failures + 1)) ;;
    esac
    return 0
}

# dotfiles
run_step ERROR copy_config "$HOME/dotfiles/shell/zshrc" "$HOME/.zshrc"
run_step ERROR copy_config "$HOME/dotfiles/shell/bashrc" "$HOME/.bashrc"
run_step ERROR copy_config "$HOME/dotfiles/shell/profile" "$HOME/.profile"
run_step ERROR copy_config "$HOME/dotfiles/shell/hushlogin" "$HOME/.hushlogin"
run_step ERROR copy_config "$HOME/dotfiles/config" "$HOME/.config"

# macOS settings
if os=$(uname); then
    :
else
    printf 'ERROR: Cannot determine operating system\n' >&2
    exit 1
fi
if [ "$os" = "Darwin" ]; then
    run_step WARNING chmod -R go-w /opt/homebrew/share
    run_step WARNING defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    run_step WARNING defaults write com.apple.desktopservices DSDontWriteLocalStores true
    run_step WARNING defaults write com.apple.desktopservices DSDontWriteUSBStores true
    run_step WARNING defaults write -g com.apple.trackpad.scaling -int 3
    run_step WARNING defaults write -g com.apple.sound.beep.volume -float 0.0
    run_step WARNING defaults write com.apple.screencapture location -string "$HOME/Downloads"
    run_step WARNING defaults write com.apple.screencapture type -string "png"
    run_step WARNING defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    run_step WARNING defaults write com.apple.finder ShowPathbar -bool true
    run_step WARNING defaults write com.apple.finder _FXSortFoldersFirst -bool true
    run_step WARNING defaults write -g KeyRepeat -int 2
    run_step WARNING defaults write -g InitialKeyRepeat -int 15
    run_step WARNING defaults write com.apple.dock tilesize -int 16
    run_step WARNING defaults write com.apple.dock autohide -bool true
    run_step WARNING defaults write com.apple.screencapture show-thumbnail -bool false
    run_step WARNING defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
    run_step WARNING defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
    run_step WARNING defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    run_step WARNING defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    run_step WARNING defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
    run_step WARNING defaults write com.microsoft.Powerpoint NSUserKeyEquivalents -dict-add "数式" "^e"
    run_step WARNING defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false
    run_step WARNING defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
    run_step WARNING defaults write com.apple.dock orientation -string left
    run_step WARNING sudo nvram BootPreference=%00
    run_step WARNING brew autoupdate start 12h --upgrade --cleanup --immediate --sudo
    run_step WARNING link_config "$HOME/Library/CloudStorage/Box-Box/" "$HOME/Box"
    run_step WARNING link_config "/opt/zerobrew/bin/podman" "/opt/zerobrew/bin/docker"
elif [ "$os" = "Linux" ]; then
    run_step WARNING link_config "$HOME/.local/share/zerobrew/prefix/bin/podman" "$HOME/.local/share/zerobrew/prefix/bin/docker"
fi

if [ "$required_failures" -ne 0 ] || [ "$optional_failures" -ne 0 ]; then
    printf 'Setup summary: %s required failure(s), %s optional failure(s)\n%s\n' \
        "$required_failures" "$optional_failures" "$failures" >&2
fi
if [ "$required_failures" -ne 0 ]; then
    exit 1
fi
exit 0
