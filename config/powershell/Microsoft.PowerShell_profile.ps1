Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

Set-Alias vim nvim

del alias:gp -Force
function git-pull { git pull $args }
Set-Alias -Name gp -Value git-pull
