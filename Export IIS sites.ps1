# Importa el módulo WebAdministration
Import-Module WebAdministration

# Obtiene la dirección IP del servidor
$serverIp = [System.Net.Dns]::GetHostAddresses($env:COMPUTERNAME) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString

# Obtiene todos los sitios en IIS
$sites = Get-ChildItem IIS:\Sites

# Define la ruta de salida del archivo de exportación
$outputPath = "SitiosIIS.csv"

# Crea un array para almacenar la información de los sitios
$siteDetails = @()

# Itera a través de cada sitio y recopila detalles
foreach ($site in $sites) {
    # Obtiene los bindings del sitio
    $bindings = $site.Bindings.Collection.BindingInformation -split ", "

    # Crea un objeto para almacenar detalles del sitio
    $siteDetail = New-Object PSObject -property @{
        'Nombre del Sitio' = $site.Name
        'ID del Sitio' = $site.Id
        'Estado del Sitio' = $site.State
        'Puerto' = $bindings[0].Split(":")[-1]
        'IP del Servidor' = $serverIp
        'Ruta Física' = $site.PhysicalPath
        'Bindings' = $bindings -join ', '
    }

    # Agrega los detalles del sitio al array
    $siteDetails += $siteDetail
}

# Exporta los detalles de los sitios a un archivo CSV
$siteDetails | Export-Csv -Path $outputPath -NoTypeInformation

Write-Host "Detalles de los sitios exportados correctamente a $outputPath"

