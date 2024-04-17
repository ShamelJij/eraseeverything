# Overwrite all free space with random data
$drive = Get-WmiObject Win32_Volume | Where-Object {$_.DriveType -eq 3 -and $_.DriveLetter -ne $null}

foreach ($d in $drive) {
    Write-Host "Overwriting free space on $($d.DriveLetter):"
    $driveLetter = $d.DriveLetter + ":\"
    $freeSpace = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$driveLetter'" | Select-Object FreeSpace
    $sizeGB = [math]::Round($freeSpace.FreeSpace / 1GB, 2)
    
    # Securely erase free space with random data
    $randomData = New-Object byte[] 1048576
    $random = New-Object System.Random
    $random.NextBytes($randomData)
    Write-Host "Writing random data to $($d.DriveLetter): ($sizeGB GB)"
    [System.IO.File]::WriteAllBytes("$driveLetter\random_data.tmp", $randomData)
    [System.IO.File]::Delete("$driveLetter\random_data.tmp")
}
