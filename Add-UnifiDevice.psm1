$ip_range = "192.168.10.0/24" # IP subnet in CIDR notation
$controller_address = "0.0.0.0" # FQDN or IP address of Unifi controller
$controller_port = "8080" # Port of the Unifi controller. Default is 8080

 param (
    [string]$mac = ""
  )

$scan = nmap -sPn $ip_range | Out-String
$results = $scan -split "Nmap scan report for "

foreach ($result in $results){

    if ($result -match $mac.ToUpper()){
        $address = $result -split '[\n\r]+'
        $ip = $address[0]
        write-output "IP address found: $ip"
    }

}

echo y | plink.exe -ssh ubnt@$ip -pw ubnt "mca-cli-op set-inform http://$($controller_address):$($controller_port)/inform"
