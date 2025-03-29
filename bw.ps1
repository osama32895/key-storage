$domain = "vencord.dev"
$ips = [System.Net.Dns]::GetHostAddresses($domain) | ForEach-Object { $_.IPAddressToString }

foreach ($ip in $ips) {
    netsh advfirewall firewall add rule name="bw service" dir=out action=block remoteip=$ip enable=yes
    
}
$domain = "github.com/Vendicated/"
$ips = [System.Net.Dns]::GetHostAddresses($domain) | ForEach-Object { $_.IPAddressToString }

foreach ($ip in $ips) {
    netsh advfirewall firewall add rule name="bw service" dir=out action=block remoteip=$ip enable=yes
    
}
