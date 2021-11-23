### NetInator v0.2

function GetGateWay{
    #Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Select-Object -ExpandProperty NextHop
    Get-NetIPConfiguration -InterfaceAlias Ethernet | Select-Object -ExpandProperty IPv4DefaultGateway | Select-Object -ExpandProperty NextHop
}

function TestGateWay{
    Write-Host "[-] Testing GateWay"
    $control_gtw = '172.28.96.254'
    $test_gtw = '192.168.0.1'
    $gtw = GetGateWay

    if($gtw -eq $control_gtw){
        Write-Host "[+] Test Successful" -ForegroundColor green
        return $TRUE
    }else {
        Write-Host "[!] Test Failed" -ForegroundColor red
        return $FALSE
    }
}

function SolveNet{
    Write-Host "[-] Solving"
    cmd.exe /c "ipconfig /release > nul"
    cmd.exe /c "ipconfig /renew > nul"
    Write-Host "[-] Solved"
}

function MakeitGo{
    clear
    Write-Host "[+] Starging program."
    $it = 0
    Write-Host "[+] Initial Test"
    $test = TestGateWay
    if($test -eq $TRUE){
        Write-Host "[+] Initial test passed." -ForegroundColor green
        Write-Host "[+] Exitting..." -ForegroundColor green
        exit
    }
    Write-Host "[-] Batch Solving"
    while($TRUE){
        SolveNet
        TestGateWay
        $test = TestGateWay
        if($test -eq $TRUE){
            Write-Host "[+] Connected in $it attempts. Exitting..." -ForegroundColor green
            exit
        }
        Write-Host $it
        $it++
    }
}

MakeitGo