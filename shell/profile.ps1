$env:PATH += ";$HOME\scoop\apps\git\current\bin"

$env:XDG_CACHE_HOME = "$HOME\.cache"
$env:XDG_CONFIG_HOME = "$HOME\.config"
$env:XDG_DATA_HOME = "$HOME\.local\share"
$env:GIT_SSH_COMMAND = '"C:\Windows\System32\OpenSSH\ssh.exe" -F "$HOME\.ssh\config"'

Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

Set-Alias -Name c -Value clear
Set-Alias -Name open -Value Invoke-Item
Set-Alias -Name lg -Value lazygit
Set-Alias -Name top -Value ntop

function cdr { cd ~/work }
function la { eza -a -g --icons --sort Name $args }
function ll { eza -l -a -g --icons --sort Name $args }
function lt { eza -T --git-ignore --sort Name $args }
function vim { nvim -O $args }
function gs { git status -s --ignored $args }
function gd { git diff $args }
function ga { git add $args }
function gf { git push $args }
function gt { ga -A ; gc ; gp ; gf }
function venv {
    uv venv .venv --python $args[0]
    if ($LASTEXITCODE -eq 0) {
        Set-Content -Path ".envrc" -Value ".venv\Scripts\Activate.ps1"
    }
    if ($LASTEXITCODE -eq 0) {
        direnv allow
    }
}

del alias:where -Force
Set-Alias -Name which -Value where.exe

del alias:rm -Force
Set-Alias -Name rm -Value rip

del alias:diff -Force
Set-Alias -Name diff -Value delta

del alias:cat -Force
function bat-cat { bat -p  --theme "Visual Studio Dark+" $args }
Set-Alias -Name cat -Value bat-cat

del alias:ls -Force
function ls-eza { eza -g --icons --sort Name $args }
Set-Alias -Name ls -Value ls-eza

del alias:gp -Force
function git-pull { git pull $args }
Set-Alias -Name gp -Value git-pull

del alias:gc -Force
function git-commit { git commit -v -t $HOME\.config\git\commit $args }
Set-Alias -Name gc -Value git-commit

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

cd $HOME/work
