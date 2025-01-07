#run with `Invoke-Expression -Command $(Invoke-WebRequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/bootstrap.ps1)`
#install pwsh 7
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& { Set-Item -Path Env:TASK_X_REMOTE_TASKFILES -Value 1; task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/pwsh.taskfile.yaml -y install }"
    Start-Process powershell -Verb runAs -ArgumentList "-Command $arguments" -Wait
}

#install scoop
if(-not (get-command scoop -erroraction silentlycontinue)){
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
#install git via scoop if git not found
if(-not  (get-command git -erroraction silentlycontinue)){scoop install git}

#install task
if(-not (get-command task -erroraction silentlycontinue)){
scoop install main/task
}
#allow remote task
$ENV:TASK_X_REMOTE_TASKFILES=1


#install helm
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/helm.taskfile.yaml -y install

#install docker desktop
if( -not(get-command docker -erroraction silentlycontinue)){
invoke-expression -command $(invoke-webrequest https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/install-docker-desktop_win.ps1)
}
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

Write-Host "You should now run: `n`tgit clone https://github.com/CyoneDev/iac-k8s-aks.git`nGo to that directory and run`n`ttask kind:init:dev"
