# Ruta de la carpeta
$rutaCarpeta = "\\pasolini\integramedica\Integramedica Los Militares\A"

try {
    # Obtiene el nombre del usuario actualmente logueado
    $usuarioActual = $env:USERNAME

    # Obtiene el objeto de seguridad de la carpeta
    $objetoSeguridad = Get-Acl -Path $rutaCarpeta

    # Define el nuevo conjunto de permisos (Control Total) para el usuario actual
    $nuevosPermisos = $usuarioActual, "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow"

    # Crea una nueva regla de acceso
    $nuevaRegla = New-Object System.Security.AccessControl.FileSystemAccessRule($nuevosPermisos)

    # Agrega la nueva regla al objeto de seguridad
    $objetoSeguridad.AddAccessRule($nuevaRegla)

    # Establece al usuario actual como propietario de la carpeta
    $objetoSeguridad.SetOwner([System.Security.Principal.NTAccount] $usuarioActual)

    # Establece los nuevos permisos y propietario en la carpeta y sus subdirectorios
    Set-Acl -Path $rutaCarpeta -AclObject $objetoSeguridad

    # Obtiene la lista de archivos y subdirectorios
    $archivos = Get-ChildItem -Path $rutaCarpeta -Recurse
    $totalArchivos = $archivos.Count
    $progreso = 0

    # Recursivamente aplica los permisos a todos los archivos y subdirectorios
    foreach ($archivo in $archivos) {
        $progreso++
        $porcentaje = ($progreso / $totalArchivos) * 100
        Write-Progress -Activity "Actualizando permisos" -Status "Procesando archivo $progreso de $totalArchivos" -PercentComplete $porcentaje

        $objetoSeguridad = Get-Acl -Path $archivo.FullName
        $objetoSeguridad.AddAccessRule($nuevaRegla)
        Set-Acl -Path $archivo.FullName -AclObject $objetoSeguridad
    }

    Write-Progress -Activity "Actualizando permisos" -Status "Proceso completado" -Completed
    Write-Host "Permisos y propietario para $usuarioActual actualizados correctamente en la carpeta y sus subdirectorios."
}
catch {
    Write-Host "Error: $_"
}
