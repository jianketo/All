# Parámetros
$tiempoMaximo = 31536000  # Duración máxima de la política HSTS en segundos (1 año)

# Obtener todos los sitios web en el servidor
$sitiosWeb = Get-WebSite

# Iterar a través de cada sitio web y configurar HSTS
foreach ($sitioWeb in $sitiosWeb) {
    $nombreSitioWeb = $sitioWeb.Name
    $rutaConfiguracion = "IIS:\Sites\$nombreSitioWeb"

    # Habilitar HSTS
    Set-WebConfigurationProperty -pspath $rutaConfiguracion -filter "system.webServer/httpProtocol/customHeaders" -name "." -value @{
        name  = "Strict-Transport-Security"
        value = "max-age=$tiempoMaximo; includeSubDomains"
    }

    # Confirmar la configuración
    Write-Host "Configuración de HSTS aplicada con éxito para el sitio $nombreSitioWeb."
}
