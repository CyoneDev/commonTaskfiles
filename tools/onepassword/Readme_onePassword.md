## Using this
in your own project's task file, you can utilize this onepassword libary:
- add an 'includes' to the git remote 
- add the set-opsecrets task below
- set a vars: SECRETS_DIR like below to a directory that your project has with the onepass secret .tpl
  - .tpl is just template file 
  - .env, .yaml .json ect ... you can set up a file that your code is going to use, and have the onepassword inject it with the actual secret at runtime    
  - for example: 
    - you have a .env.tpl file with HELM_CYONE_JFROG_URL="op://VaultName/SecretName/KeyName"
    - set-opsecrets will examine any files ending in .tpl in the directory and replace onepassword secret refrerences with the actual secret
    
```yaml 

version: '3'

includes:
  op: https://raw.githubusercontent.com/CyoneDev/commonTaskfiles/main/tools/onepassword/onepassword_{{OS}}.yaml # This is the remote taskfile in the git repo

dotenv: ["secrets/helm-config.env"]

vars:
  SECRETS_DIR: "./secrets" #this is a directory included in your project that contains '.tpl' files to replace with secrets from onepass 

tasks:
  set-opsecrets:
    desc: "Ensure 1Password CLI is installed and OP_SERVICE_ACCOUNT_TOKEN is set. Inject secrets into .env file."
    deps: [op:install] #ensures onepasscli is installed
    cmds:
      - task op:check-token-valid # ensures onepasscli has a set OP_Service_Account_Token environment variable
      - task op:inject-secrets -- DIR "{{.SECRETS_DIR}}" #runs the task that will replace tokens in any .tpl file in the SECRETS_DIR directory

```
