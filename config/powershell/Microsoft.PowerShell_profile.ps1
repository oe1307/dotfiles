# set this file in $PROFILE

Import-Module PSReadLine
Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit
Set-Alias vim nvim

$ENV:Path="C:\Program Files\LLVM\bin;"+$ENV:Path
