<#
.Synopsis
This script enables Powershell remoting on servers and installs software.

$Type1= "admin"
$Type2= "user"

-Dante Foulke, 2018

.Description
Run on a server Locally to enable Remoting. 
Also Enables Windows Remoting Service, Remote Registry Service and Remote Procedure Call Service

Change "YOURSERVER01,YOURSERVER02" to a specified list of trusted servers to receive powershell commands from.

#>


[CmdletBinding()]
    Param(
        [parameter(Mandatory=$false)]
        [String]
        $Type,

        [parameter(Mandatory=$false)]
        [Switch]
        $PostRestart
    )

$Type1= "admin"
$Type2= "user"

    if( $Type -like $Type1 ){
        $main="y"
        $choco="y"
        $wsl="y"
        $ssh="y"
    }

    if( $Type -like $Type2 ){
        $main="y"
        $choco="y"
        $wsl="n"
        $ssh="n"
    }

    if( $PostRestart.IsPresent ){
        $main="n"
        $choco="n"
        $wsl="n"
        $ssh="n"
    }


if($main -like "y"){
    Update-Help -Force

    #Intialize Powershell and Powershell Remoting
    Set-ExecutionPolicy RemoteSigned -force
    Enable-PSRemoting -force
    Set-Item WSMan:\localhost\Client\TrustedHosts "Rivendale, Winterfell" -force

    #Enable Windows Remoting Service
    $service = "WinRM"
    $result = (gwmi win32_service -filter "name='$service'").ChangeStartMode("Automatic")
    $result = (gwmi win32_service -filter "name='$service'").startservice()

    #Enable Remote Procedure Call Service
    $service = "RpcSs"
    $result = (gwmi win32_service -filter "name='$service'").ChangeStartMode("Automatic")
    $result = (gwmi win32_service -filter "name='$service'").startservice()
    
    #Enable Remote Registry Service
    $service = "RemoteRegistry"
    $result = (gwmi win32_service -filter "name='$service'").ChangeStartMode("Automatic")
    $result = (gwmi win32_service -filter "name='$service'").startservice()

    if($choco -like "y"){
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Install-PackageProvider Nuget –Force
        Install-Module –Name PowerShellGet –Force -AllowClobber
        Update-Module -Name PowerShellGet
        Update-Module -Name Packagemanagement
    }

    if($wsl -like "y"){
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
    }

    if($ssh -like "y"){
        Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
        Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        Start-Service sshd
        Set-Service -Name sshd -StartupType 'Automatic'
        Get-NetFirewallRule -Name *ssh*
    }

    Update-Module -Force
    Restart-Computer -Force
}



if($PostRestart.IsPresent){
    #AFTER RESTART#
    #choco install adb -Y
    choco install anaconda3 -Y
    choco install audacity -Y
    choco install audacity-lame -Y
    choco install audacity-ffmpeg -Y
    #choco install avirafreeantivirus -Y
    choco install brave -Y
    choco install calibre -Y
    choco install ccleaner -Y
    choco install chocolatey -Y
    #choco install etcher -Y
    choco install epicgameslauncher -Y
    #choco install evernote -Y
    choco install ffdshow -Y
    choco install flashplayerplugin -Y
    choco install flashplayerppapi -Y
    # choco install firefox -Y
    choco install foxitreader -Y
    choco install gimp -Y
    choco install git -Y
    choco install github-desktop -Y
    choco install googlechrome -Y
    #choco install haali-media-splitter -Y
    choco install joplin -Y
    choco install kindle -Y
    choco install lastpass -Y
    #choco install mediamonkey -Y
    #choco install mixxx -Y
    #choco install musicbee -Y
    choco install nextcloud-client -Y
    choco install notepadplusplus -Y
    #choco install obs-studio -Y
    choco install picard -Y
    choco install putty -Y
    choco install royalts -Y
    choco install screenpresso -Y
    #choco install signal -Y
    choco install steam -Y
    choco install superputty -Y
    choco install thunderbird -Y
    choco install tor-browser -Y
    choco install visualstudio2019community -Y
    choco install vlc -Y
    #choco install winpcap -Y
    #choco install winscp -Y
    #choco install wireshark -Y
    choco install 7zip -Y

}

