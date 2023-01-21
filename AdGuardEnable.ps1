if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$server = "143.47.243.68"

Write-Host "----------------------------------------------------------------`n                   AdGuard Enable Script             `n----------------------------------------------------------------`nThis script enables AdGuard system-wide on your machine to block ads.`nNote: sites you visit may be logged on the AdGuard server." -ForegroundColor Green

Write-Host "`nPress any key to begin!" -NoNewline
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Clear-Host

Write-Host "----------------------------------------------------------------`n                     Check AdGuard Server?             `n----------------------------------------------------------------" -ForegroundColor Yellow

$checksv = Read-Host "Let's begin the setup of AdGuard on this computer!`nBefore you set AdGuard up, would you like to check whether the server is working? (Y/N) [Y]"

if ($null -eq $checksv -or $checksv -eq "") {
    $checksv = "y"
}

if ($checksv -eq "y") {
    Write-Host "Testing DNS server..." -ForegroundColor Cyan

    $ErrorActionPreference = "silentlycontinue"
    $ProgressPreference = "SilentlyContinue"
    $Global:ProgressPreference = 'SilentlyContinue'

    $testsv = (Test-NetConnection $server -Port 53).TcpTestSucceeded
    if ($testsv) {
        Write-Host "DNS Server is active!" -ForegroundColor Green -BackgroundColor Black
    }
    else {
        Write-Host "DNS Server is not active..." -ForegroundColor Red -BackgroundColor Black
        Write-Host "Don't worry though! If you continue the setup for AdGuard, next time it comes online you'll be all ready to go!"
    }

    Write-Host "`nPress any key to head to next step!" -NoNewline
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

Clear-Host

Write-Host "----------------------------------------------------------------`n                     Configuring AdGuard             `n----------------------------------------------------------------" -ForegroundColor Yellow

$checkcf = Read-Host "Would you like to use Cloudflare as your secondary DNS? (this means if the AdGuard Server goes down you won't loose internet access) (Y/N) [Y]"

if ($null -eq $checkcf -or $checkcf -eq "") {
    $checkcf = "y"
}

try {
    if ($checkcf -eq "y") {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $server, 1.1.1.1
    }
    elseif ($checkcf -eq "n") {
        Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses $server
    }
    Write-Host "Complete!" -ForegroundColor Green -BackgroundColor Black
}
catch {
    Write-Host "An error occurred!" -ForegroundColor Red -BackgroundColor Black
}

Write-Host "`nPress any key to exit this script." -NoNewline
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');