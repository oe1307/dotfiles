$env:XDG_CONFIG_HOME = "$HOME\.config"
$env:GIT_SSH_COMMAND = '"C:\Windows\System32\OpenSSH\ssh.exe" -F "$HOME\.ssh\config"'

Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

Set-Alias -Name c -Value clear
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name lg -Value lazygit

del alias:where -Force
Set-Alias -Name which -Value where.exe

del alias:rm -Force
Set-Alias -Name rm -Value rip

del alias:diff -Force
Set-Alias -Name diff -Value delta

function cd-work { cd ~/work }
Set-Alias -Name cdr -Value cd-work

del alias:cat -Force
function bat-cat { bat -p  --theme "Visual Studio Dark+" $args }
Set-Alias -Name cat -Value bat-cat

del alias:ls -Force
function ls-eza { eza -g --icons --sort Name $args }
Set-Alias -Name ls -Value ls-eza

function ls-all { eza -a -g --icons --sort Name $args }
Set-Alias -Name la -Value ls-all

function ls-list { eza -l -a -g --icons --sort Name $args }
Set-Alias -Name ll -Value ls-list

function ls-tree { eza -T --git-ignore --sort Name $args }
Set-Alias -Name lt -Value ls-tree

function nvim-multi { nvim -O $args }
Set-Alias -Name vim -Value nvim-multi

del alias:gp -Force
function git-pull { git pull $args }
Set-Alias -Name gp -Value git-pull

function git-status { git status -s --ignored $args }
Set-Alias -Name gs -Value git-status

function git-diff { git diff $args }
Set-Alias -Name gd -Value git-diff

function git-add { git add $args }
Set-Alias -Name ga -Value git-add

del alias:gc -Force
function git-commit { git commit -v -t $HOME\.config\git\commit.txt $args }
Set-Alias -Name gc -Value git-commit

function git-push { git push $args }
Set-Alias -Name gf -Value git-push

function sudo {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $Command
    )

    if (-not $Command -or $Command.Count -eq 0) {
        Start-Process powershell -Verb RunAs
        return
    }

    $cmdText  = $Command -join ' '
    $bytes    = [Text.Encoding]::Unicode.GetBytes($cmdText)
    $encoded  = [Convert]::ToBase64String($bytes)

    Start-Process pwsh -Verb RunAs -ArgumentList @(
        '-NoExit', '-NoProfile', '-ExecutionPolicy', 'Bypass',
        '-EncodedCommand', $encoded
    )
}

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
