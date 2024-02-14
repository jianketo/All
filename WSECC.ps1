$RegistryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
$Entry1 = "FeatureSettingsOverrideMask"
$Entry2 = "FeatureSettingsOverride"
$Value1 = 3
$Value2 = 72

# Verificar si la entrada del registro 1 existe y tiene el valor correcto
if ((Get-ItemProperty -Path $RegistryKey -Name $Entry1 -ErrorAction SilentlyContinue).$Entry1 -ne $Value1) {
    Write-Host "$Entry1 no se encontro o tiene un valor incorrecto. Agregando entrada..."
    Set-ItemProperty -Path $RegistryKey -Name $Entry1 -Value $Value1
} else {
    Write-Host "$Entry1 ya existe la entrada con el valor correcto."
}

# Verificar si la entrada del registro 2 existe y tiene el valor correcto
if ((Get-ItemProperty -Path $RegistryKey -Name $Entry2 -ErrorAction SilentlyContinue).$Entry2 -ne $Value2) {
    Write-Host "$Entry2 no se encontro o tiene un valor incorrecto. Agregando entrada..."
    Set-ItemProperty -Path $RegistryKey -Name $Entry2 -Value $Value2
} else {
    Write-Host "$Entry2 ya existe la entrada con el valor correcto."
}

Write-Host "Ejecucion del script completada."