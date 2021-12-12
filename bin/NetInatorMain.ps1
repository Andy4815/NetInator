### NetInator v0.3

function GetGateway{
    #Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop
    Get-NetIPConfiguration -InterfaceAlias Ethernet | Select-Object -ExpandProperty IPv4DefaultGateway | Select-Object -ExpandProperty NextHop
}

function TestGateway{
    #Write-Host "[-] Testing Gateway"
    $control_gtw = '172.28.96.254'
    $test_gtw = '192.168.0.1'
    $gtw = GetGateway

    if($gtw -eq $control_gtw){
        #Write-Host "[+] Test Successful" -ForegroundColor green
        return $TRUE
    }else {
        #Write-Host "[!] Test Failed" -ForegroundColor red
        return $FALSE
    }
}

function SolveNet{
    #Write-Host "[-] Solving"
    cmd.exe /c "ipconfig /release > nul"
    cmd.exe /c "ipconfig /renew > nul"
    #Write-Host "[-] Solved"
}

function MakeitGo{
    $it = 1
    $test = TestGateway
    $network_name = Get-NetIPConfiguration -InterfaceAlias Ethernet | Select-Object -ExpandProperty NetProfile | Select-Object -ExpandProperty Name
    if($test -eq $TRUE){
        Write-Host "[+] Internet is already working. Connected on $network_name" -ForegroundColor green
        exit
    }
    Write-Host "[!] Repairing..."
    while($TRUE){
        SolveNet
        TestGateway > $nul
        $test = TestGateway
        if($test -eq $TRUE){
            Write-Host "[+] Connected in $it attempts on $network_name" -ForegroundColor green
            exit
        }
        Write-Host "[-] Attempt $it on $network_name"
        $it++
    }
}

function Self_Sign{
    $folder = "C:\Users\$env:USERNAME\AppData\Roaming\NetInator"

    if(!(Test-Path $folder)){
        New-Item -ItemType Directory $folder -Force > $nul
    }

    $path = "$folder\Signature.file"
    if(!(Test-Path $path)){
        New-Item $path > $nul
        $var = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($env:USERNAME)) | Out-File $path -Force
        (Get-Item $path).Attributes += 'Hidden' 
    }
}

function Main{
    clear
    $art = "
  _   _          _     _                   _                  
 | \ | |        | |   (_)                 | |                 
 |  \| |   ___  | |_   _   _ __     __ _  | |_    ___    _ __ 
 | . ` |  / _ \ | __| | | | '_ \   / _` | | __|  / _ \  | '__|
 | |\  | |  __/ | |_  | | | | | | | (_| | | |_  | (_) | | |   
 |_| \_|  \___|  \__| |_| |_| |_|  \__,_|  \__|  \___/  |_|   
                                                              
                                                              
"
    Write-Host $art
    Write-Host "[+] Starting program"
    Self_Sign
    MakeitGo
}

Main