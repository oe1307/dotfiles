Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

Set-Alias vim nvim
function cd-home { cd ~ }
Set-Alias -Name cdr -Value cd-home

del alias:gp -Force
function git-pull { git pull $args }
Set-Alias -Name gp -Value git-pull

function git-status { git status $args }
Set-Alias -Name gs -Value git-status
