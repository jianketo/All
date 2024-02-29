# Instalar el módulo Import-Excel si no está instalado
if (-not (Get-Module -Name ImportExcel -ErrorAction SilentlyContinue)) {
    Install-Module -Name ImportExcel -Force -AllowClobber -Scope CurrentUser
}

# Importar el módulo Import-Excel
Import-Module ImportExcel

# Ruta del escritorio del usuario
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

# Obtener el nombre del servidor
$serverName = hostname

# Ruta completa para el archivo Excel
$excelFilePath = Join-Path $desktopPath "IIS_INFO_$serverName.xlsx"

# Obtener todos los sitios de IIS excluyendo el sitio predeterminado
$sites = Get-WebSite | Where-Object { $_.Name -ne 'Default Web Site' }

# Crear una lista para almacenar los resultados
$results = @()

foreach ($site in $sites) {
    # Agregar información del sitio principal
    $siteStatus = if ($site.State -eq 'Started') { 'Running' } else { 'Stop' }
    $applicationPool = Get-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$($site.Name)']" -Name applicationPool -PSPath IIS:\Sites\$($site.Name) | Select-Object -ExpandProperty Value

    if ($applicationPool -eq $null) {
        $applicationPool = "No Aplica"
    }

    $siteInfo = [PSCustomObject]@{
        'Sitio'            = $site.Name
        'Bindings'         = ($site.Bindings.Collection | ForEach-Object { "$($_.Protocol) $($_.BindingInformation)" }) -join ', '
        'VirtualPath'      = "No Aplica"  # Para el sitio principal, no hay Virtual Path
        'RutaFisica'       = $site.PhysicalPath
        'EstadoSitio'      = $siteStatus
        'ApplicationPool'  = $applicationPool
    }

    $results += $siteInfo

    # Agregar información de subdirectorios (aplicaciones)
    $applications = Get-WebApplication -Site $site.Name

    foreach ($app in $applications) {
        $appStatus = if ($app.State -eq 'Started') { 'Running' } else { 'Stop' }
        $appPool = Get-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$($site.Name)']/application[@path='$($app.Path)']" -Name applicationPool -PSPath IIS:\Sites\$($site.Name) | Select-Object -ExpandProperty Value

        if ($appPool -eq $null) {
            $appPool = "No Aplica"
        }

        $appInfo = [PSCustomObject]@{
            'Sitio'            = $site.Name
            'Bindings'         = "No Aplica"  # Para subdirectorios, no hay bindings directos
            'VirtualPath'      = $app.Path
            'RutaFisica'       = $app.PhysicalPath
            'EstadoSitio'      = $appStatus
            'ApplicationPool'  = $appPool
        }

        $results += $appInfo
    }
}

# Exportar los resultados a un archivo Excel
$results | Export-Excel -Path $excelFilePath -AutoSize -FreezeTopRow -BoldTopRow

Write-Host "La información de los sitios de IIS ha sido exportada a: $excelFilePath"
