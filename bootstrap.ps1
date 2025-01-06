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
 
 
Write-Host "You should now `ngit clone https://github.com/CyoneDev/iac-k8s-aks.git`n"
Write-Host "Go to that directory and run 'task:init:dev'"
 


#kluctl
  #kluctl
  #kind
  #wisrd
    #wisrdlicense
    
