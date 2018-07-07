Param (
  [string]$DD,
  [string]$Image,
  [string]$Device,
  [string]$Vhd,
  [string]$VMName
)
Begin {
}
Process {
  Stop-VM -Name $VMName -TurnOff
  Mount-DiskImage $Vhd
  Write-Host $DD if=$Image of=$Device bs=512 count=15
  & $DD if=$Image of=$Device bs=512 count=15
  Dismount-DiskImage $Vhd
  Start-VM -Name $VMName
}
End {
}
