<#
.SYNOPSIS
    This script installs applications and tools commonly used by professional developers on a fresh Windows installation.

.DESCRIPTION
    The script installs Visual Studio Code, Azure CLI, Azure Data Studio, SQL Server Developer Edition, Google Chrome, Mozilla Firefox,
    and other essential tools for development. It installs Visual Studio 2022 Community edition.

.NOTES
    Script Name: Install-DeveloperWorkstationSBP.ps1
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

# Define the URL for Visual Studio 2022 Community license terms
$communityUrl = "https://visualstudio.microsoft.com/license-terms/vs2022-ga-community/"
Write-Host "For license terms of Visual Studio 2022 Community, please visit: $communityUrl"

Write-Host "Creating Small Business/Personal Developer Workstation From Fresh Windows Install"

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
Install-Application -AppName "Acrobat" -AppIdentifier "Adobe.Acrobat.Reader.64-bit"
Install-Application -AppName "Chrome" -AppIdentifier "Google.Chrome"
Install-Application -AppName "Firefox" -AppIdentifier "Mozilla.Firefox"
Install-Application -AppName "SQL Tools" -AppIdentifier "Microsoft.Sqlcmd"
Install-Application -AppName "SQL Server Developer" -AppIdentifier "Microsoft.SQLServer.2022.Developer"
Install-Application -AppName "Azure Data Studio" -AppIdentifier "Microsoft.AzureDataStudio"
Install-Application -AppName "SQL Server Management Studio" -AppIdentifier "Microsoft.SQLServerManagementStudio"
Install-Application -AppName "Teams" -AppIdentifier "Microsoft.Teams"
Install-Application -AppName "GitHub Desktop" -AppIdentifier "GitHub.GitHubDesktop"
Install-Application -AppName "Visual Studio 2022 Community" -AppIdentifier "Microsoft.VisualStudio.2022.Community --silent --override --wait --quiet --installWhileDownloading --add ProductLang En-us --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Component.CoreEditor  --add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.Data --add Microsoft.VisualStudio.Workload.Azure --add Microsoft.VisualStudio.Workload.NetCrossPlat --add Microsoft.VisualStudio.Workload.NetWeb --includeRecommended"

# Update all installed packages using winget
Write-Host "Updating installed packages..."
winget update --all

Write-Host "END"
