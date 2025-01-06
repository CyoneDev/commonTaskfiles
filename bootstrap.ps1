#install scoop
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
#install git via scoop if git not found
if(-not  (get-command git)){scoop install git}

#install task
scoop bucket add main
scoop install main/task
$ENV:TASK_X_REMOTE_TASKFILES=1


#install helm
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/helm.taskfile.yaml -y install
#install pwsh 7
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/pwsh.taskfile.yaml -y install
#install docker desktop
invoke-expression $(curl https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/install-docker-desktop_win.ps1 | select -expand content)
