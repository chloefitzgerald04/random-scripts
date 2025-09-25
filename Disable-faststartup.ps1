$key = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$item = "HiberbootEnabled"
$value = Get-itempropertyvalue -path $key -name $item

if (-not(Get-Itemproperty -Path $key -Name $item)) {

    write-host "Reg reg does not exist"
    New-Itemproperty -path $Key -name "HiberbootEnabled" -value "0" -PropertyType "dword" | out-null

} elseif ($value -ne 0){

    Write-host "$item not set to 0"
    Set-ItemProperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -name "HiberbootEnabled" -value "0" | out-null
    
} else {
    Write-host "$item set to 0 already"
}
