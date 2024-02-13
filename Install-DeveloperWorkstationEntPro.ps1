<#
.SYNOPSIS
    This script installs applications and tools commonly used by professional developers on a fresh Windows installation.

.DESCRIPTION
    The script installs Visual Studio Code, Azure CLI, Azure Data Studio, SQL Server Developer Edition, Google Chrome, Mozilla Firefox,
    Microsoft Office, and other essential tools for development. It also provides the option to install Visual Studio 2022 Professional
    or Enterprise edition based on user choice.

.NOTES
    Script Name: Install-DeveloperWorkstationEntPro.ps1
    Author: Tom Blanchard
    Date: February 6 2024

#>

# Function to check for internet connection
function Test-InternetConnection {
    $connected = $false
    try {
        $request = [System.Net.WebRequest]::Create("http://www.google.com")
        $response = $request.GetResponse()
        $connected = $response.StatusCode -eq "OK"
        $response.Close()
    } catch {
        $connected = $false
    }
    return $connected
}

# Function to install applications
function Install-Application {
    param (
        [string]$AppName,
        [string]$AppIdentifier
    )

    Write-Host "Installing $AppName"
    
    # Run winget to install the application
    $installResult = winget install $AppIdentifier

    # Check if the installation result indicates that the product is already installed
    if ($installResult.ExitCode -eq $null) {
        Write-Host "$AppName is already installed"
    }
    # Check if the installation was successful
    elseif ($installResult.ExitCode -eq 0) {
        Write-Host "$AppName installed successfully"
    } else {
        Write-Warning "Failed to install $AppName. Exit code: $($installResult.ExitCode)"
        # Display error log if available
        if ($installResult.ErrorLog -ne $null) {
            Write-Host "Error log for $($AppName):"
            Write-Host $installResult.ErrorLog
        }
    }
}

# Function to prompt user for Visual Studio edition choice
function Prompt-VisualStudioEdition {
    Write-Host "Which edition of Visual Studio do you want to install?"
    Write-Host "1. Professional"
    Write-Host "2. Enterprise"
    
    $choice = Read-Host "Enter your choice (1 or 2)"
    return $choice
}

# Check internet connection
if (-not (Test-InternetConnection)) {
    Write-Host "No internet connection found. Please connect to the internet and try again."
    exit
}

# Define download URLs
$professionalUrl = "https://aka.ms/vs/17/release/vs_professional.exe"
$enterpriseUrl = "https://aka.ms/vs/17/release/vs_enterprise.exe"

# Prompt user for Visual Studio edition choice
$vsEditionChoice = Prompt-VisualStudioEdition

# Download and run Visual Studio installer
if ($vsEditionChoice -eq "1") {
    $installerUrl = $professionalUrl
} elseif ($vsEditionChoice -eq "2") {
    $installerUrl = $enterpriseUrl
} else {
    Write-Warning "Invalid choice. Please choose 1 for Professional or 2 for Enterprise."
    exit
}

# Download installer
$downloadDirectory = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('UserProfile'), 'Downloads')
$installerPath = Join-Path -Path $downloadDirectory -ChildPath "vs_installer.exe"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Wait until the download is complete
$downloadComplete = $false
$previousFileSize = -1
$timeoutInSeconds = 300  # Adjust timeout as needed (e.g., 5 minutes)

$timeout = [System.DateTime]::Now.AddSeconds($timeoutInSeconds)

while (-not $downloadComplete -and [System.DateTime]::Now -lt $timeout) {
    Start-Sleep -Seconds 5  # Check every 5 seconds

    $currentFileSize = (Get-Item $installerPath).Length

    if ($currentFileSize -eq $previousFileSize) {
        $downloadComplete = $true
    } else {
        $previousFileSize = $currentFileSize
    }
}

if ($downloadComplete) {
    Write-Host "Download complete. Proceeding to install."
    # Run installer with specified options
    Start-Process -FilePath $installerPath -ArgumentList "--layout C:\VSLayout --lang en-US" -Wait
} else {
    Write-Host "Download did not complete within the specified timeout. Aborting installation."
    exit
}

# Install other applications
Write-Host "Installing other applications..."

Install-Application -AppName "VSCode" -AppIdentifier "Microsoft.VisualStudioCode"
Install-Application -AppName "Terminal" -AppIdentifier "Microsoft.WindowsTerminal"
Install-Application -AppName "AzureCLI" -AppIdentifier "Microsoft.AzureCLI"
Install-Application -AppName "DataCLI" -AppIdentifier "Microsoft.AzureDataCLI"
Install-Application -AppName "Azure StorageExplorer" -AppIdentifier "Microsoft.AzureStorageExplorer"
Install-Application -AppName "PowerBI" -AppIdentifier "Microsoft.PowerBI"
Install-Application -AppName "Powershell7" -AppIdentifier "Microsoft.PowerShell"
Install-Application -AppName "RDP" -AppIdentifier "Microsoft.RemoteDesktopClient"
Install-Application -AppName "OneDrive Enterprise" -AppIdentifier "Microsoft.OneDriveForBusiness"
Install-Application -AppName "Acrobat" -AppIdentifier "Adobe.Acrobat.Reader.64-bit"
Install-Application -AppName "Azure Data Studio" -AppIdentifier "Microsoft.AzureDataStudio"
Install-Application -AppName "SQL Server Management Studio" -AppIdentifier "Microsoft.SQLServerManagementStudio"
Install-Application -AppName "GitHub Desktop" -AppIdentifier "GitHub.GitHubDesktop"

# Update all installed packages using winget
Write-Host "Updating installed packages..."
winget update --all

Write-Host "END"
