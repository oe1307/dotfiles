cd $HOME/work

Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

Set-Alias -Name la -Value ls
Set-Alias -Name c -Value clear
Set-Alias -Name open -Value Invoke-Item

function ssh {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    & ssh.exe @Args 2>$null
}

function cd-home { cd ~ }
Set-Alias -Name cdr -Value cd-home

del alias:gp -Force
function git-pull { git pull $args }
Set-Alias -Name gp -Value git-pull

function git-status { git status $args }
Set-Alias -Name gs -Value git-status

function git-diff { git diff $args }
Set-Alias -Name gd -Value git-diff

function git-add { git add $args }
Set-Alias -Name ga -Value git-add

del alias:gc -Force
function git-commit { git commit $args }
Set-Alias -Name gc -Value git-commit

function git-push { git push $args }
Set-Alias -Name gf -Value git-push

function prompt() {
  $username = $env:UserName
  $computername = $env:ComputerName.ToLower()
  $drive = $pwd.Drive.Name
  $path = $pwd.path.Replace($HOME, "~").Replace("${drive}:","")
  Write-Host "$username@$computername" -ForegroundColor "DarkGreen" -NoNewLine
  Write-Host ":" -NoNewLine
  Write-Host "$path" -ForegroundColor "DarkBlue"
  Write-Host "$" -ForegroundColor "White" -NoNewLine
  return " "
}
