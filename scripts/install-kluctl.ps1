# Variables
$downloadDir = "$env:USERPROFILE\Downloads"
$outputDir = "$env:USERPROFILE\scoop\shims"

# Step 1: Fetch the latest release details
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/kluctl/kluctl/releases/latest"

# Step 2: Find the asset matching the Windows executable
$asset =$release.assets | Where-Object { $_.name -like "*windows_amd64*" }

# Step 3: Download the asset
if ($asset -ne $null) {
    $zipFilePath = Join-Path $downloadDir $asset.name
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipFilePath
    Write-Output "Downloaded: $zipFilePath"

    # Step 4: Unzip the downloaded file
    $unzipDir = Join-Path $downloadDir "kluctl_latest"
    Expand-Archive -Path $zipFilePath -DestinationPath $unzipDir -Force
    Write-Output "Unzipped to: $unzipDir"

    # Step 5: Move the binary to the scoop shims directory
    $binaryPath = Get-ChildItem -Path $unzipDir -Filter "kluctl.exe" -Recurse | Select-Object -ExpandProperty FullName
    Move-Item -Path $binaryPath -Destination $outputDir -Force
    Write-Output "Moved kluctl.exe to: $outputDir"
} else {
    Write-Error "No Windows asset found in the latest release."
}
