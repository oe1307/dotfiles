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

### Migrating from symbolic links

Existing symbolic links (including directory links) created by older versions of the setup script are skipped rather than replaced. They continue to point to their original targets.

If you want to migrate an old configuration link to an independent copy, inspect the link first and move the link itself to an unused backup path, then rerun the setup script. For example, if `~/.zshrc` is an old link to this repository:

```sh
ls -ld "$HOME/.zshrc"
# After verifying the link and choosing an unused backup path:
if [ -L "$HOME/.zshrc" ]; then
    mv -i "$HOME/.zshrc" "$HOME/.zshrc.symlink.bak"
fi
sh "$HOME/dotfiles/setup.sh"
```

Do not remove or modify the link target during migration. Keep the backup until you have verified the new configuration. The macOS Box and Podman aliases are intentionally kept as symbolic links.

## WSL: Bitwarden SSH agent

The zsh startup configuration uses a single `socat` listener to forward `~/.ssh/bitwarden-ssh-agent.sock` to the Windows OpenSSH named pipe via `npiperelay.exe`. Ensure `socat`, `npiperelay.exe`, `flock` (util-linux), `timeout` and `nohup` (GNU coreutils) are available on your PATH. Stale-socket recovery uses Linux's `/proc/net/unix`.

Run `setup.sh` to install both `.zshrc` and `~/.config/zsh/bitwarden-ssh-agent.sh`. After migrating from the previous configuration, save your work and shut down WSL from Windows once (`wsl --shutdown` stops all running distributions), then reopen a WSL terminal to clear any previously orphaned listeners. A healthy listener is reused; a stale socket is removed only under an exclusive lock and after checking that no listener owns its path. A temporary Windows-side agent failure does not trigger a relay restart.

The relay log is stored in `~/.local/state/bitwarden-ssh-agent/socat.log` (private directory). Once Bitwarden is running and its SSH agent is enabled, run `ssh-add -l` in WSL to verify end-to-end connectivity. On Linux, run `sh tests/bitwarden-ssh-agent.sh` from the repository root to exercise the relay using a simulated Windows client.
