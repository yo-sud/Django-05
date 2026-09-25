<#
.SYNOPSIS
Reparacion automatica de puertos USB/HDMI/Thunderbolt en HP Victus
.DESCRIPTION
Desactiva suspension selectiva USB, reinstala controladores, resetea puertos, limpia registro
.REQUIRES
Ejecutar como ADMINISTRADOR
#>

# Verificar admin
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "EJECUTA COMO ADMINISTRADOR (clic derecho -> Ejecutar como administrador)"
    exit 1
}

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  REPARACION PUERTOS HP VICTUS - $(Get-Date)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$rebootNeeded = $false

# 1. DESACTIVAR SUSPENSION SELECTIVA USB EN REGISTRO
Write-Host "=== 1. DESACTIVANDO SUSPENSION SELECTIVA USB ===" -ForegroundColor Yellow
$regPaths = @(
    "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009",
    "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\2a737441-1930-4402-8d77-b2bebba308a3"
)
foreach ($path in $regPaths) {
    if (Test-Path $path) {
        Set-ItemProperty -Path $path -Name "Attributes" -Value 2 -Force
        Set-ItemProperty -Path $path -Name "ACSettingIndex" -Value 0 -Force
        Set-ItemProperty -Path $path -Name "DCSettingIndex" -Value 0 -Force
        Write-Host "  Actualizado: $path"
    }
}

# Tambien en Control\Class para USB
$usbClass = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{36fc9e60-c465-11cf-8056-444553540000}"
if (Test-Path $usbClass) {
    Get-ChildItem $usbClass | ForEach-Object {
        Set-ItemProperty -Path $_.PSPath -Name "SelectiveSuspendEnabled" -Value 0 -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  SelectiveSuspendEnabled = 0 en todas las instancias USB"
}
Write-Host ""

# 2. DESACTIVAR AHORRO DE ENERGIA EN ADAPTADORES USB (POWERCFG)
Write-Host "=== 2. CONFIGURANDO POWERCFG ===" -ForegroundColor Yellow
$plan = (powercfg /getactivescheme).Split(" ")[3]
powercfg /setacvalueindex $plan 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
powercfg /setdcvalueindex $plan 2a737441-1930-4402-8d77-b2bebba308a3 d4e98f31-5ffe-4ce1-be31-1b38b384c009 0
powercfg /setactive $plan
Write-Host "  Suspension selectiva USB desactivada en plan actual"
Write-Host ""

# 3. REINSTALAR CONTROLADORES USB
Write-Host "=== 3. REINSTALANDO CONTROLADORES USB ===" -ForegroundColor Yellow
$usbControllers = Get-PnpDevice -Class "USB" -Status OK | Where-Object { $_.FriendlyName -match "Controller|Hub|Root|XHCI|EHCI" }
foreach ($dev in $usbControllers) {
    Write-Host "  Reinstalando: $($dev.FriendlyName)"
    pnputil /remove-device $dev.InstanceId /uninstall /force 2>$null
    Start-Sleep 1
}
Write-Host "  Escaneando cambios de hardware..."
pnputil /scan-devices
Start-Sleep 3
Write-Host ""

# 4. REINSTALAR DISPOSITIVOS HID (MICE/TECLADOS)
Write-Host "=== 4. REINSTALANDO DISPOSITIVOS HID ===" -ForegroundColor Yellow
$hidDevices = Get-PnpDevice -Class "HIDClass" -Status OK
foreach ($dev in $hidDevices) {
    Write-Host "  Reinstalando: $($dev.FriendlyName)"
    pnputil /remove-device $dev.InstanceId /uninstall /force 2>$null
    Start-Sleep 1
}
pnputil /scan-devices
Start-Sleep 2
Write-Host ""

# 5. LIMPIAR CACHE DE DRIVERS (DRIVERSTORE)
Write-Host "=== 5. LIMPIANDO CACHE DE DRIVERS ANTIGUOS ===" -ForegroundColor Yellow
$driverStore = "C:\Windows\System32\DriverStore\FileRepository"
if (Test-Path $driverStore) {
    $oldDrivers = Get-ChildItem $driverStore -Directory | Where-Object { 
        $_.Name -match "usb|hid|mouse|intel|amd|chipset" -and $_.LastWriteTime -lt (Get-Date).AddDays(-30)
    } | Select-Object -First 20
    foreach ($d in $oldDrivers) {
        Write-Host "  Eliminando driver antiguo: $($d.Name)"
        pnputil /delete-driver $d.Name /uninstall /force 2>$null
    }
}
Write-Host ""

# 6. REPARAR ARCHIVOS DE SISTEMA
Write-Host "=== 6. REPARANDO ARCHIVOS DE SISTEMA (SFC/DISM) ===" -ForegroundColor Yellow
Write-Host "  Ejecutando DISM (puede tardar varios minutos)..."
dism /online /cleanup-image /restorehealth /quiet
Write-Host "  Ejecutando SFC..."
sfc /scannow
$rebootNeeded = $true
Write-Host ""

# 7. RESETEAR PUERTOS USB MEDIANTE PNPUTIL
Write-Host "=== 7. RESETEO COMPLETO DE PUERTOS USB ===" -ForegroundColor Yellow
$hubDevices = Get-PnpDevice -Class "USB" | Where-Object { $_.FriendlyName -match "Hub|Root" }
foreach ($hub in $hubDevices) {
    $id = $hub.InstanceId
    Write-Host "  Reseteando: $($hub.FriendlyName)"
    pnputil /disable-device $id /force 2>$null
    Start-Sleep 1
    pnputil /enable-device $id /force 2>$null
    Start-Sleep 1
}
Write-Host ""

# 8. DESACTIVAR INICIO RAPIDO (FAST STARTUP)
Write-Host "=== 8. DESACTIVANDO INICIO RAPIDO ===" -ForegroundColor Yellow
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
if (Test-Path $regPath) {
    Set-ItemProperty -Path $regPath -Name "HiberbootEnabled" -Value 0 -Force
    Write-Host "  HiberbootEnabled = 0 (Inicio rapido desactivado)"
    $rebootNeeded = $true
}
Write-Host ""

# 9. CONFIGURAR SERVICIOS USB
Write-Host "=== 9. CONFIGURANDO SERVICIOS USB ===" -ForegroundColor Yellow
$services = @(
    @{Name="usbhub3"; Startup="Automatic"},
    @{Name="USBXHCI"; Startup="Automatic"},
    @{Name="UCX01000"; Startup="Automatic"},
    @{Name="WpdBusEnum"; Startup="Automatic"},
    @{Name="hidserv"; Startup="Automatic"}
)
foreach ($svc in $services) {
    $s = Get-Service $svc.Name -ErrorAction SilentlyContinue
    if ($s) {
        Set-Service $svc.Name -StartupType $svc.Startup -ErrorAction SilentlyContinue
        if ($s.Status -ne 'Running') { Start-Service $svc.Name -ErrorAction SilentlyContinue }
        Write-Host "  $($svc.Name): $($svc.Startup)"
    }
}
Write-Host ""

# 10. LIMPIAR REGISTRO DE DISPOSITIVOS FANTASMA
Write-Host "=== 10. LIMPIANDO DISPOSITIVOS FANTASMA ===" -ForegroundColor Yellow
$env:DEVMGR_SHOW_NONPRESENT_DEVICES = "1"
Write-Host "  Variable DEVMGR_SHOW_NONPRESENT_DEVICES=1 establecida"
Write-Host "  Abre 'Administrador de dispositivos' -> Ver -> Mostrar dispositivos ocultos"
Write-Host "  Desinstala dispositivos grises (fantasma) bajo 'Controladores de bus USB' y 'Ratones y otros dispositivos de puntero'"
Write-Host ""

# 11. ACTUALIZAR FIRMWARE HP (INFORMACION)
Write-Host "=== 11. ACTUALIZACION DE BIOS/FIRMWARE (MANUAL) ===" -ForegroundColor Yellow
Write-Host "  CRITICO EN HP VICTUS: Actualiza BIOS desde:" -ForegroundColor Red
Write-Host "  https://support.hp.com/drivers" -ForegroundColor Cyan
Write-Host "  Busca tu modelo exacto (ej: Victus 15-fb0xxx, 16-d0xxx, etc.)" -ForegroundColor Cyan
Write-Host "  Descarga e instala la BIOS MAS RECIENTE (F.XX)" -ForegroundColor Cyan
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  REPARACION AUTOMATICA COMPLETADA" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($rebootNeeded) {
    Write-Host "SE REQUIERE REINICIO" -ForegroundColor Red -BackgroundColor Yellow
    Write-Host "Ejecuta: shutdown /r /t 0" -ForegroundColor White
    $confirm = Read-Host "Reiniciar ahora? (S/N)"
    if ($confirm -eq 'S' -or $confirm -eq 's') {
        shutdown /r /t 0
    }
} else {
    Write-Host "Reinicio recomendado pero no obligatorio." -ForegroundColor Yellow
}