<# 
.SYNOPSIS
Diagnostico completo de puertos USB/HDMI/Thunderbolt en HP Victus
.DESCRIPTION
Revisa drivers, gestion de energia, eventos de sistema, estado de hardware y configuracion BIOS
.NOTES
Ejecutar como ADMINISTRADOR
#>

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DIAGNOSTICO PUERTOS HP VICTUS - $(Get-Date)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# 1. INFO DEL SISTEMA
Write-Host "=== 1. INFORMACION DEL SISTEMA ===" -ForegroundColor Yellow
$cs = Get-CimInstance Win32_ComputerSystem
$bios = Get-CimInstance Win32_BIOS
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Modelo: $($cs.Model)"
Write-Host "Fabricante: $($cs.Manufacturer)"
Write-Host "BIOS: $($bios.SMBIOSBIOSVersion) - $($bios.ReleaseDate)"
Write-Host "OS: $($os.Caption) $($os.Version)"
Write-Host ""

# 2. DISPOSITIVOS USB CON PROBLEMAS
Write-Host "=== 2. DISPOSITIVOS USB (CON ERRORES) ===" -ForegroundColor Yellow
$usbDevices = Get-PnpDevice -Class "USB" -Status Error,Unknown,Degraded 2>$null
if ($usbDevices) {
    $usbDevices | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
} else {
    Write-Host "No hay dispositivos USB con errores visibles" -ForegroundColor Green
}
Write-Host ""

# 3. CONTROLADORES USB Y CHIPSET
Write-Host "=== 3. CONTROLADORES USB Y CHIPSET ===" -ForegroundColor Yellow
$controllers = Get-PnpDevice -Class "System" | Where-Object { $_.FriendlyName -match "(USB|Chipset|PCI|Thunderbolt|Controller)" }
$controllers | Format-Table Status, Class, FriendlyName -AutoSize
Write-Host ""

# 4. GESTION DE ENERGIA USB (SUSPENSION SELECTIVA)
Write-Host "=== 4. CONFIGURACION ENERGIA USB ===" -ForegroundColor Yellow
$powerSettings = @(
    "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3",
    "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\d4e98f31-5ffe-4ce1-be31-1b38b384c009"
)
foreach ($path in $powerSettings) {
    if (Test-Path $path) {
        $val = Get-ItemProperty $path
        Write-Host "Clave: $path"
        $val.PSObject.Properties | Where-Object { $_.Name -match "Attributes|DefaultValue|ACSettingIndex|DCSettingIndex" } | ForEach-Object {
            Write-Host "  $($_.Name): $($_.Value)"
        }
    }
}
Write-Host ""

# 5. PLAN DE ENERGIA ACTIVO
Write-Host "=== 5. PLAN DE ENERGIA ACTIVO ===" -ForegroundColor Yellow
$activePlan = powercfg /getactivescheme
Write-Host $activePlan
$planGuid = ($activePlan -split " ")[3]
powercfg /query $planGuid | Select-String "USB|usb|Selective|Suspend" | ForEach-Object { Write-Host "  $_" }
Write-Host ""

# 6. EVENTOS DEL SISTEMA (ULTIMAS 24H)
Write-Host "=== 6. ERRORES USB/PCI EN EVENTOS (24H) ===" -ForegroundColor Yellow
$events = Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = @('USB', 'USBHUB3', 'USBXHCI', 'PCI', 'ACPI', 'Kernel-PnP')
    StartTime = (Get-Date).AddHours(-24)
    Level = 1,2,3
} -MaxEvents 30 -ErrorAction SilentlyContinue

if ($events) {
    $events | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize -Wrap
} else {
    Write-Host "Sin eventos criticos recientes" -ForegroundColor Green
}
Write-Host ""

# 7. DRIVERS CON PROBLEMAS
Write-Host "=== 7. DRIVERS SIN FIRMA O CON PROBLEMAS ===" -ForegroundColor Yellow
Get-WindowsDriver -Online -All | Where-Object { $_.BootCritical -eq $true -or $_.DriverProviderName -notlike "*Microsoft*" } | 
    Select-Object PublishedName, ClassName, DriverProviderName, Date, Version | Format-Table -AutoSize
Write-Host ""

# 8. DISPOSITIVOS HID (MICE/TECLADOS)
Write-Host "=== 8. DISPOSITIVOS HID (MICE/TECLADOS) ===" -ForegroundColor Yellow
Get-PnpDevice -Class "HIDClass" | Format-Table Status, Class, FriendlyName, InstanceId -AutoSize
Write-Host ""

# 9. CONTROLADORES DE BUS PCI (CHIPSET)
Write-Host "=== 9. PUENTES PCI / CHIPSET ===" -ForegroundColor Yellow
Get-PnpDevice -Class "System" | Where-Object { $_.FriendlyName -match "PCI|Bridge|Chipset|ISA|SMBus|LPC" } | Format-Table Status, Class, FriendlyName -AutoSize
Write-Host ""

# 10. THUNDERBOLT / USB4 (SI EXISTE)
Write-Host "=== 10. THUNDERBOLT / USB4 ===" -ForegroundColor Yellow
$tb = Get-PnpDevice | Where-Object { $_.FriendlyName -match "Thunderbolt|USB4" }
if ($tb) { $tb | Format-Table Status, Class, FriendlyName } else { Write-Host "No detectado" }
Write-Host ""

# 11. SERVICIOS RELACIONADOS
Write-Host "=== 11. SERVICIOS CRITICOS ===" -ForegroundColor Yellow
$services = @("usbhub3", "USBXHCI", "UCX01000", "WpdBusEnum", "hidserv", "mouclass", "mouhid")
foreach ($svc in $services) {
    $s = Get-Service $svc -ErrorAction SilentlyContinue
    if ($s) { Write-Host "$($s.Name): $($s.Status) - $($s.StartType)" }
}
Write-Host ""

# 12. TEMPERATURA Y ENERGIA (SI DISPONIBLE)
Write-Host "=== 12. SENSORES TERMICOS / BATERIA ===" -ForegroundColor Yellow
Get-CimInstance Win32_Battery | Format-Table EstimatedChargeRemaining, BatteryStatus, Chemistry -AutoSize
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  DIAGNOSTICO COMPLETADO" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "PROXIMOS PASOS RECOMENDADOS:" -ForegroundColor Yellow
Write-Host "1. Ejecuta el script de reparacion: .\reparar-puertos.ps1" -ForegroundColor White
Write-Host "2. Actualiza BIOS desde web de HP (critico en Victus)" -ForegroundColor White
Write-Host "3. Instala drivers de chipset AMD/Intel desde web del fabricante" -ForegroundColor White
Write-Host "4. Desactiva 'Suspension selectiva USB' en Plan de energia" -ForegroundColor White