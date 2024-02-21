# Conectarse a su servidor vCenter
$vcServer = "svr-vsan.bupa.cl"
$vcUser = "borrasnapshot@vsphere.local"
$vcPass = "xxxxx"

# Cargar las credenciales de vCenter
$SecurePassword = ConvertTo-SecureString $vcPass -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ($vcUser, $SecurePassword)

# Leer el archivo de texto que contiene la lista de máquinas virtuales
$VMs = Get-Content -Path "C:\snap.txt"

# Conectarse al servidor vCenter
Connect-VIServer -Server $vcServer -Credential $Credentials

# Iterar sobre la lista de máquinas virtuales y tomar un snapshot de cada una
foreach ($VM in $VMs) {
    New-Snapshot -VM $VM -Name "Snapshot_Auto_$(Get-Date -Format 'yyyyMMdd')" -Description "Snapshot automático creado por script PowerShell" -Memory
}

# Desconectarse del servidor vCenter
Disconnect-VIServer -Server $vcServer -Confirm:$false
