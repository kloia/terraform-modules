# Client VPN Module
This `client-vpn` module is making you able to deploy VPN with TLS certificates.
Module usage 

## Generate Certificates
Before you make the module call, you should run the the script, that containing tls generation capabilities.

* Execute the script like that :

```
$ ./scripts/generate_cert.sh daas.company.vpn client1
```
This script is populating certificates to the `cert` directory .

## Module Call

```
module "vpn_client" {
    dns_servers = ["1.1.1.1"]
    subnet_list = ["sub-123", "sub-124"]
    is_split_tunnel = false
    is_access_internet = true
}
```