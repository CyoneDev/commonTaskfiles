#run with `Invoke-Expression -Command $(Invoke-WebRequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/bootstrap.ps1)`

#install scoop
if(-not (get-command scoop -erroraction silentlycontinue)){
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
#install git via scoop if git not found
if(-not  (get-command git -erroraction silentlycontinue)){scoop install git}
#install gum
if(-not (get-command gum -erroraction silentlycontinue)){scoop install main/charm-gum}
#install task
if(-not (get-command task -erroraction silentlycontinue)){
scoop install main/task
}
#allow remote task
$ENV:TASK_X_REMOTE_TASKFILES=1

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
#install pwsh 7 and docker desktop within UAC elevated prompt
if( -not(get-command pwsh -erroraction silentlycontinue)){
    $arguments = "& { Set-Item -Path Env:TASK_X_REMOTE_TASKFILES -Value 1; task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/pwsh.taskfile.yaml -y install ;invoke-expression -command `$(invoke-webrequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/install-docker-desktop_win.ps1)}"
    Start-Process powershell -Verb runAs -ArgumentList "-Command $arguments" -Wait
}
}


#install helm
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/helm.taskfile.yaml -y install


#kind
if(-not (get-command kind -erroraction silentlycontinue)){scoop install kind}
#kluctl
if(-not (get-command kluctl -erroraction silentlycontinue)){
Invoke-Expression -Command $(Invoke-WebRequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/install-kluctl.ps1)
}
#onepassword
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/main/tools/onepassword/onepassword_windows.yaml install -y
#kubectl
scoop install kubectl
Invoke-Expression -Command $(Invoke-WebRequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/Refresh-EnvironmentVariables.ps1)

# Define ANSI color codes
$DarkGreen = "`e[32m" # Dark green color
$ResetColor = "`e[0m" # Reset to default color

# Write the message as a single Write-Host command
Write-Host "$DarkGreen###############`nYou should now reboot`n###############$ResetColor`n`nAfter rebooting:`n`n$DarkGreen         Open Docker Desktop if it was installed for first time`n$ResetColor`From a location with your git repos:`n   Clone the git repo: `n`t$DarkGreen git clone https://github.com/CyoneDev/iac-k8s-aks.git $ResetColor`nGo to that directory and run`n`t$DarkGreen task kind:init:dev $ResetColor"
