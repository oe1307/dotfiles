tap "chipsalliance/verible"
tap "randomplum/gtkwave"
brew "chipsalliance/verible/verible"
brew "randomplum/gtkwave/gtkwave"

brew "bat"
brew "cmake"
brew "direnv"
brew "eza"
brew "git-delta"
brew "htop"
brew "lazygit"
brew "neovim"
brew "node"
brew "rip2"
brew "starship"
brew "tree-sitter-cli"
brew "zsh"
brew "zsh-autopair"
brew "zsh-autosuggestions"
brew "zsh-completions"
brew "zsh-syntax-highlighting"
cask "font-hackgen-nerd"

if OS.mac?
brew "marp-cli"
brew "mas"
cask "box-drive"
cask "codex"
cask "google-chrome"
brew "icarus-verilog"
cask "microsoft-powerpoint"
cask "raycast"
cask "spotify"
cask "wezterm"
mas "Pure Paste", id: 1611378436
mas "Xcode", id: 497799835
elsif OS.linux?
end

# python
brew "ipython"
brew "pyright"
brew "ruff"
brew "isort"
brew "flake8"

# lua
brew "stylua"
brew "lua-language-server"
