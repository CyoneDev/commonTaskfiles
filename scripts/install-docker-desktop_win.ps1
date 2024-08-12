# Define variables
$dockerDownloadUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller.exe"

# Function to download Docker Desktop
function Download-DockerDesktop {
    Write-Host "Downloading Docker Desktop installer..."
    Invoke-WebRequest -Uri $dockerDownloadUrl -OutFile $installerPath
    Write-Host "Download complete!"
}

# Function to install Docker Desktop
function Install-DockerDesktop {
    Write-Host "Installing Docker Desktop..."
    Start-Process -FilePath $installerPath -ArgumentList "/quiet" -Wait
    Write-Host "Installation complete!"
}

# Function to check if Docker Desktop is already installed
function Check-DockerInstalled {
    Write-Host "Checking if Docker Desktop is already installed..."
    $dockerInstalled = Get-Command "docker" -ErrorAction SilentlyContinue
    if ($dockerInstalled) {
        Write-Host "Docker Desktop is already installed."
        return $true
    } else {
        Write-Host "Docker Desktop is not installed."
        return $false
    }
}

# Main script logic
if (-not (Check-DockerInstalled)) {
    Download-DockerDesktop
    Install-DockerDesktop
} else {
    Write-Host "Docker Desktop is already installed. No action needed."
}

# Clean up the installer
if (Test-Path $installerPath) {
    Remove-Item $installerPath
    Write-Host "Cleaned up the installer."
}
