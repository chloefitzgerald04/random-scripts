


##########################################
############ - <Variables> - ############

$reg_path = "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint"
$reg_type = "DWORD"
$reg_name = "RestrictDriverInstallationToAdministrators"
$reg_value = "0"

############ - </Variables> - ############
##########################################


# Tests if the full path exists - if not then it creates it and sets the DWORD
if ((Test-Path $reg_path) -eq $false){

    New-item -path $reg_path -Force | out-null
    New-ItemProperty -Path $reg_path -Name $reg_name -value $reg_value -PropertyType $reg_type -Force | Out-Null
    Exit 0

#Tests if DWORD is present in path - if not then creates it
} elseif ((Get-Item $reg_path).property -notcontains $reg_name){

    New-ItemProperty -Path $reg_path -Name $reg_name -value $reg_value -PropertyType $reg_type -Force | Out-Null
    Exit 0

#Tests if DWORD is set properly - if not it updates the value  
} elseif ((Get-itempropertyvalue -path $reg_path -name $reg_name) -ne $reg_value){

    Set-ItemProperty -Path $reg_path -Name $reg_name -value $reg_value -Force | Out-Null
    Exit 0

# All checks passed
} else {
    Exit 0
}
