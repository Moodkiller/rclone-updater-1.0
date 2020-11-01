# rclone install/update script by Moodkiller
# Version 2.0

# Beta tester?? (NB do not move this block)
param(
$beta='N', 
$location='C:\Windows\System32'
)

if ($beta -eq $null) {$beta = Read-Host -Prompt "Download and install Beta version (Y/N)?"}
if ($64 -eq $null) {if ([IntPtr]::Size -eq 8){$64 = $true}}

# Work out if 64 or 32 bit rclone is required
#if ([IntPtr]::Size -eq 8){$64 = $true}

# Set URL's accordinly
if(($64) -and ($beta -ieq "Y")){$url = "https://beta.rclone.org/rclone-beta-latest-windows-amd64.zip";$VerURL = "https://beta.rclone.org/version.txt"}
elseif (($64) -and (!($beta -ieq "Y"))){$url = "https://downloads.rclone.org/rclone-current-windows-amd64.zip";$VerURL = "https://downloads.rclone.org/version.txt"}
elseif ((!($64)) -and (($beta -ieq "Y"))){$url = "https://beta.rclone.org/rclone-beta-latest-windows-386.zip";$VerURL = "https://beta.rclone.org/version.txt"}
elseif ((!($64)) -and (!($beta -ieq "Y"))){$url = "https://downloads.rclone.org/rclone-current-windows-386.zip";$VerURL = "https://downloads.rclone.org/version.txt"}

# USER VARIABLES #
# param($location='C:\Windows\System32')
$PASS = 'Write-Host "[PASS] " -ForegroundColor Green -NoNewline'
$WARN = 'Write-Host "[Warning] " -ForegroundColor Yellow -NoNewline'
$FAIL = 'Write-Host "[FAIL] " -ForegroundColor Red -NoNewline'
$INFO = 'Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline'

function Test-Admin {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Running as Admin?
if (Test-Admin) {
Invoke-Expression $PASS;Write-Host "Running script with admin privileges"
} else {
    Invoke-Expression $WARN;Write-Host "Running script without admin privileges"
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip {
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function Check-PowershellVersion {
    $version = $PSVersionTable.PSVersion.Major
    Invoke-Expression $PASS;Write-Host "Checking Windows PowerShell version: $version"
    if ($version -le 2)
    {
        Invoke-Expression $FAIL;Write-Host "Using Windows PowerShell $version is unsupported. Please upgrade your Windows PowerShell."
        Invoke-Expression $INFO;Write-Host "Go to (https://github.com/PowerShell/PowerShell/releases/latest) to get the latest release."
        throw
        Exit 0
    }
}

function Test-Write {
$random = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 25 | % {[char]$_})
if (!(test-path $location)) {Invoke-Expression $INFO;Write-Host "$location doesn't exist, creating...";New-Item -ItemType Directory -Force -Path $location | Out-Null}
try{"TESTWRITE" | Out-File -FilePath $location\$random -ErrorAction SilentlyContinue}catch{Invoke-Expression $FAIL;Write-Host $_.Exception.Message}
$wrote = (Test-Path $location\$random -ErrorAction SilentlyContinue)
if ($wrote){
    Remove-Item $location\$random -ErrorAction SilentlyContinue
    Invoke-Expression $PASS;Write-host "Installation directory ($location) is writtable."
    }else{
        if (!(Test-Admin)){Invoke-Expression $FAIL;Write-Host "($location) is unwrittable, script is not running with Admin privileges"}
        #throw
        exit 0
    }  
}


function Install-rclone {
if (!(Get-ChildItem "$location\rclone.exe" -ErrorAction SilentlyContinue)) { 
    Invoke-Expression $INFO;Write-Host "rclone doesn't appear to be installed in a system"'$PATH.'""
    Download-rclone
    } else {
    Update-rclone
    }
}

function Update-rclone {
    Invoke-Expression $INFO;Write-Host "Checking local version vs current version..."
    $version = & rclone.exe --version | Select -First 1
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $VerURL -OutFile "$env:TEMP\version.txt"
    $current_version = Get-Content "$env:TEMP\version.txt" -First 1
    if ($version -ieq $current_version) {
        Invoke-Expression $INFO;Write-Host "You currently have the latest verstion ($version) of rclone installed. No update requried."
        Exit 0
        } else { Invoke-Expression $INFO;Write-Host "You have $version, updating to $current_version";Download-rclone }
    }


function Download-rclone {
    $filename = $URL.Substring($URL.LastIndexOf("/") + 1) 
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-Expression $INFO;Write-Host "Downloading ($filename)...";Invoke-WebRequest -Uri $url -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox -outfile "$env:TEMP\$filename"
    # Extract-rclone
    Expand-Archive -Force -LiteralPath "$env:TEMP\$filename" -DestinationPath "$env:TEMP\rclone";Invoke-Expression $INFO;Write-Host "Extracting" $filename
    Get-ChildItem "$env:TEMP\rclone\rclone-*\*.exe" | Copy-Item -Destination "$location" -Force;Invoke-Expression $INFO;Write-Host "Copying" (Get-ChildItem "$env:TEMP\rclone\rclone-*\*.exe" -Name) "to $location\rclone.exe"
    Remove-Item $env:TEMP\rclone -Recurse;Invoke-Expression $INFO;Write-Host "Deleting temp downloaded files..."
    Remove-Item $env:TEMP\rclone*.zip
    }

try {
    Check-PowershellVersion
    Test-Write
    Install-rclone
    Invoke-Expression $PASS;Write-Host "Operation completed!"
    & rclone.exe --version -q
    exit 0
}
catch [System.Exception] {
    Invoke-Expression $FAIL;Write-Host $_.Exception.Message
    exit 1
}
