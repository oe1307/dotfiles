# dotfiles
New-Item -ItemType Directory -Force -Path "$HOME\.config"
New-Item -ItemType SymbolicLink `
  -Path "$HOME\.config\git" `
  -Target "$HOME\dotfiles\config\git"