# dotfiles

<div align="center">
  <img alt="AdvKit" width=50% src="https://dotfiles.github.io/images/dotfiles-logo.png">
  <h3>dotfiles for git/nvim/zsh/...</h3>

  <img src="https://img.shields.io/github/license/oe1307/dotfiles?logo=open-source-initiative&logoColor=green">
  <img src="https://img.shields.io/github/last-commit/oe1307/dotfiles?logo=git&logoColor=white">
  <img src="https://img.shields.io/github/issues/oe1307/dotfiles?logo=github&logoColor=white">
  <img src="https://img.shields.io/github/issues-pr/oe1307/dotfiles?logo=github&logoColor=white">
  <img src="https://img.shields.io/github/languages/code-size/oe1307/dotfiles?logo=github&logoColor=white">
</div>


## Setup

Clone the repository into `~/dotfiles` and run the setup script:

```sh
cd "$HOME" && git clone https://github.com/oe1307/dotfiles.git && sh "$HOME/dotfiles/setup.sh"
```

The setup script copies configuration files into your home directory and `~/.config`.
Existing regular files are overwritten only after confirmation.

## Update

Installed configuration files are independent copies, not symbolic links.
Pulling changes into the repository does not automatically update the installed copies.

To fetch and apply the latest configuration:

```sh
git -C "$HOME/dotfiles" pull --ff-only && sh "$HOME/dotfiles/setup.sh"
```

- Review each overwrite prompt: enter `y` to replace the installed file or `n` to keep your local version.
- Back up or merge any local changes you want to retain before accepting an overwrite. Changes made to installed copies are not automatically reflected in the repository either.
- Unrelated local files are preserved. Files removed from the repository are not automatically removed from the destination.
- Restart or reload the affected applications or shell sessions as needed.

On macOS, rerunning `setup.sh` also reapplies system preferences, runs Homebrew-related commands, and handles the Box and Podman symbolic links. It may request administrator privileges.
