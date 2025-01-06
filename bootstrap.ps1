#install scoop
if(-not (get-command scoop)){
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
#install git via scoop if git not found
if(-not  (get-command git)){scoop install git}

#install task
if(-not (get-command task)){
scoop install main/task
}
#allow remote task
$ENV:TASK_X_REMOTE_TASKFILES=1


#install helm
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/helm.taskfile.yaml -y install
#install pwsh 7
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/installs/pwsh.taskfile.yaml -y install
#install docker desktop
if( -not(get-command dockerd)){
invoke-expression $(curl https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/refs/heads/main/scripts/install-docker-desktop_win.ps1 | select -expand content)
}
#kind
if(-not (get-command kind -erroraction silentlycontinue)){scoop install kind}
#onepass op cli
task -t https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/main/tools/onepassword/onepassword_windows.yaml install -y

Write-Host "You should now run: `n`tgit clone https://github.com/CyoneDev/iac-k8s-aks.git`nGo to that directory and run`n`ttask kind:init:dev"

 


#kluctl
  #kluctl
  #kind
  #wisrd
    #wisrdlicense
    
