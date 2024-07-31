Param(
    $akvSecretName,
    $akvVaultName,
    $AZ_SUBSCRIPTION_ID
)
process{

#if not set then login to azure with azure account and pull the key from azure keyvault 
#basically i'm using the azure keyvault login process to authenticate that the user should have the key

# Ensure the Az.KeyVault module is installed
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
install-module -Name Az.KeyVault -AllowClobber -Scope CurrentUser -MinimumVersion 6.0.1 -AcceptLicense -Force
install-module -Name Az.Accounts -AllowClobber -Scope CurrentUser -MinimumVersion 3.0.2 -AcceptLicense -Force

# Authenticate to Azure if not already authenticated
$azureContexts = Get-AzContext -ListAvailable  
if ($null -eq $azureContexts -or $azureContexts.Count -eq 0) {
    Write-Output "No Azure contexts available. Initiating login..."
    Update-AzConfig -EnableLoginByWam $true -DefaultSubscriptionForLogin $AZ_SUBSCRIPTION_ID | Out-Null
    Connect-AzAccount -UseDeviceAuthentication
} else {
    $currentContext = Get-AzContext
    if ($null -eq $currentContext) {
        Write-Output "Setting Azure context to the first available context..."
        Set-AzContext -Context $azureContexts[0]
    }
    # Extend here for additional context checks if necessary
}

# Retrieve the secret from Azure Key Vault
Write-Output "Retrieving secret from Azure Key Vault..."

function ConvertFrom-SecureStringToPlainText {
    param (
        [Parameter(Mandatory = $true)]
        [System.Security.SecureString]$SecureString
    )

    $Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
    try {
        [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Ptr)
    }
    finally {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Ptr)
    }
}
$secureString = (Get-AzKeyVaultSecret -VaultName $akvVaultName -Name $akvSecretName).SecretValue
$retrievedSecretValue = ConvertFrom-SecureStringToPlainText -SecureString $secureString

# Set the OP_SESSION environment variable for the current user with the retrieved secret value
$targetScope = [System.EnvironmentVariableTarget]::User
Set-EnvVar -KeyName OP_SERVICE_ACCOUNT_TOKEN -KeyValue $retrievedSecretValue





}
begin{
    function Set-EnvVar {
        param (
            [string]$KeyName,
            [string]$KeyValue
        )
    
        function Set-LinuxOrMacOSVar {
            param (
                [string]$profilePath,
                [string]$KeyName,
                [string]$KeyValue
            )
    
            $profilePath = (Resolve-Path -Path $profilePath).ToString()
            $profileContent = Get-Content -Path $profilePath -ErrorAction SilentlyContinue
            $variableLine = "export $KeyName=$KeyValue"
    
            if ($profileContent) {
                $existingLine = $profileContent | Select-String -Pattern "export\s+$KeyName="
    
                if ($existingLine) {
                    $newContent = $profileContent -replace "export\s+$KeyName=.*", $variableLine
                    Set-Content -Path $profilePath -Value $newContent
                    Write-Host "Updated environment variable $KeyName in $profilePath"
                } else {
                    Add-Content -Path $profilePath -Value $variableLine
                    Write-Host "Added environment variable $KeyName to $profilePath"
                }
            } else {
                Add-Content -Path $profilePath -Value $variableLine
                Write-Host "Added environment variable $KeyName to $profilePath"
            }
        }
    
        switch ($true) {
            $IsLinux {
                
                Set-LinuxOrMacOSVar -profilePath "~/.bashrc" -KeyName $KeyName -KeyValue $KeyValue
                Set-Item -Path "ENV:$KeyName" -Value $KeyValue
                break
            }
            $IsMacOS {
                
                Set-LinuxOrMacOSVar -profilePath "~/.bash_profile" -KeyName $KeyName -KeyValue $KeyValue
                Set-Item -Path "ENV:$KeyName" -Value $KeyValue
                break
            }
            $IsWindows {
    
                [System.Environment]::SetEnvironmentVariable($KeyName, $KeyValue, [System.EnvironmentVariableTarget]::User)
                Write-Host "Environment variable $KeyName set permanently for the user"
                Set-Item -Path "ENV:$KeyName" -Value $KeyValue
                break
            }
            default {
            }
        }
    }
}