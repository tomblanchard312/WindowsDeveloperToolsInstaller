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

# Define the URL for Visual Studio 2022 Professional license terms
$professionalUrl = "https://visualstudio.microsoft.com/license-terms/vs2022-ga-proenterprise/"
Write-Host "For license terms of Visual Studio 2022 Professional, please visit: $professionalUrl"

# Define the URL for Visual Studio 2022 Enterprise license terms
$enterpriseUrl = "https://visualstudio.microsoft.com/license-terms/vs2022-ga-proenterprise/"
Write-Host "For license terms of Visual Studio 2022 Enterprise, please visit: $enterpriseUrl"

Write-Host "Creating Professional Developer Workstation From Fresh Windows Install"

# Install applications
Install-Application -AppName "VSCode" -AppIdentifier "Microsoft.VisualStudioCode"
Install-Application -AppName "Terminal" -AppIdentifier "Microsoft.WindowsTerminal"
Install-Application -AppName "AzureCLI" -AppIdentifier "Microsoft.AzureCLI"
Install-Application -AppName "DataCLI" -AppIdentifier "Microsoft.AzureDataCLI"
Install-Application -AppName "Azure StorageExplorer" -AppIdentifier "Microsoft.AzureStorageExplorer"
Install-Application -AppName "PowerBI" -AppIdentifier "Microsoft.PowerBI"
Install-Application -AppName "PowerAutomate Desktop" -AppIdentifier "Microsoft.PowerAutomateDesktop"
Install-Application -AppName "Powershell7" -AppIdentifier "Microsoft.PowerShell"
Install-Application -AppName "RDP" -AppIdentifier "Microsoft.RemoteDesktopClient"
Install-Application -AppName "OneDrive Enterprise" -AppIdentifier "Microsoft.OneDriveForBusiness"
Install-Application -AppName "Acrobat" -AppIdentifier "Adobe.Acrobat.Reader.64-bit"
Install-Application -AppName "Chrome" -AppIdentifier "Google.Chrome"
Install-Application -AppName "Firefox" -AppIdentifier "Mozilla.Firefox"
Install-Application -AppName "SQL Tools" -AppIdentifier "Microsoft.Sqlcmd"
Install-Application -AppName "SQL Server Developer" -AppIdentifier "Microsoft.SQLServer.2022.Developer"
Install-Application -AppName "Azure Data Studio" -AppIdentifier "Microsoft.AzureDataStudio"
Install-Application -AppName "SQL Server Management Studio" -AppIdentifier "Microsoft.SQLServerManagementStudio"
Install-Application -AppName "Teams" -AppIdentifier "Microsoft.Teams"
Install-Application -AppName "GitHub Desktop" -AppIdentifier "GitHub.GitHubDesktop"
Install-Application -AppName "Microsoft Office 365 Apps for Enterprise" -AppIdentifier "Microsoft.Office"

# Prompt user for Visual Studio edition choice
$vsEditionChoice = Prompt-VisualStudioEdition

# Install Visual Studio based on user's choice
if ($vsEditionChoice -eq "1") {
    Install-Application -AppName "Visual Studio 2022 Professional" -AppIdentifier "Microsoft.VisualStudio.2022.Professional --silent --override --wait --quiet --installWhileDownloading --add ProductLang En-us --includeRecommended"
} elseif ($vsEditionChoice -eq "2") {
    Install-Application -AppName "Visual Studio 2022 Enterprise" -AppIdentifier "Microsoft.VisualStudio.2022.Enterprise --silent --override --wait --quiet --installWhileDownloading --add ProductLang En-us --includeRecommended"
} else {
    Write-Warning "Invalid choice. Please choose 1 for Professional or 2 for Enterprise."
}

# Update all installed packages using winget
Write-Host "Updating installed packages..."
winget update --all

Write-Host "END"
