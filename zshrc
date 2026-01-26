#!/bin/zsh

cd $HOME/work

# PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=$HOME/.homebrew/bin:$PATH
export PATH=$HOME/.homebrew/sbin:$PATH

# settings
export COLORTERM=truecolor
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export LESSHISTFILE=$HOME/.local/state/lesshst
export HISTFILE=$HOME/.local/state/zsh_history
export SCREENRC=$HOME/.config/screen/screenrc
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export MPLCONFIGDIR=$XDG_CACHE_HOME/matplotlib
export ZSH_AUTO=$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_SYNTAX=$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH_AUTOPAIR=$(brew --prefix)/share/zsh-autopair/autopair.zsh
export BAT_THEME="Visual Studio Dark+"
export APPLE_SSH_ADD_BEHAVIOR=macos
export EDITOR=nvim
export FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
export NPM_CONFIG_USERCONFIG=$HOME/.config/node_js/npmrc
export IPYTHONDIR=$HOME/.cache/ipython
export PYTHONWARNINGS="ignore::UserWarning:IPython.core.interactiveshell"
if [ ! -e "$HISTFILE" ]; then mkdir -p "$(dirname "$HISTFILE")" && touch "$HISTFILE"; fi
if [ -e "$ZSH_AUTO" ]; then source $ZSH_AUTO; else echo "zsh-autosuggestions not found"; fi
if [ -e "$ZSH_SYNTAX" ]; then source $ZSH_SYNTAX; else echo "zsh-syntax-highlighting not found"; fi
if [ -e "$ZSH_AUTOPAIR" ]; then source $ZSH_AUTOPAIR; else echo "zsh-autopair not found"; fi

# options
HISTSIZE=100000
SAVEHIST=100000
setopt prompt_subst
setopt +o nonomatch
setopt share_history
setopt append_history
setopt auto_param_slash
setopt mark_dirs
setopt interactive_comments
setopt magic_equal_subst
setopt complete_in_word
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store

# git
alias gs="git status -s --ignored"
alias gp="git pull"
alias ga="git add"
alias gf="git push"
alias gS="git stash push"
alias gc="git commit"
alias go="git checkout"
alias gb="git branch"
alias gd="git diff"
alias gl="git log"
alias lg="lazygit"
alias gt="ga -A && gc -v -t ~/.config/git/commit.txt && gp && gf"

# alias
alias c="clear"
alias cdr="cd $HOME/work"
alias diff="delta"
alias mv="mv -i"
alias cp="cp -i -r"
alias grep="grep --color=auto -d skip"
alias nvidia-smi="watch -n 1 nvidia-smi"
alias venv="python -m venv .venv && echo 'source .venv/bin/activate' > .envrc && direnv allow ."
alias bb="brew bundle --file $HOME/.config/homebrew/Brewfile.rb && brew upgrade"
alias bbc="brew bundle cleanup -f --file $HOME/.config/homebrew/Brewfile.rb && brew cleanup"
alias bbd="brew bundle dump -f --file $HOME/.cache/Brewfile && diff $HOME/.cache/Brewfile $HOME/.config/homebrew/Brewfile.rb"
alias checkpy="pyright . && ruff format . && isort . --profile=black && flake8 **/*.py --max-line-length=88"
if hash starship 2>/dev/null; then eval "$(starship init zsh)"; else echo "starship not found"; fi
if hash direnv 2>/dev/null; then eval "$(direnv hook zsh)"; else echo "direnv not found"; fi
if hash eza 2>/dev/null; then alias ls="eza -g --icons --sort Name"; else echo "eza not found"; fi
if hash eza 2>/dev/null; then alias la="eza -a -g --icons --sort Name"; else alias la="ls -a"; fi
if hash eza 2>/dev/null; then alias ll="eza -l -a -g --icons --sort Name"; else alias ll="ls -la"; fi
if hash eza 2>/dev/null; then alias lt="eza -T --git-ignore --sort Name"; fi
if hash bat 2>/dev/null; then alias cat="bat -p"; else echo "bat not found"; fi
if hash htop 2>/dev/null; then alias top="htop"; else echo "htop not found"; fi
if hash nvim 2>/dev/null; then alias vim="nvim -O"; else echo "nvim not found"; fi
if hash rip 2>/dev/null; then alias rm="rip"; else echo "rip2 not found"; fi
if hash ipython 2>/dev/null; then alias python="ipython"; else echo "ipython not found"; fi
