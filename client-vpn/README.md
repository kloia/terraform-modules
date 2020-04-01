# Client VPN Module
This `client-vpn` module is making you able to deploy ClientVPN with TLS authentication.

Module usage be formed by two main parts:
    * Generate Certificates
    * Module Calling

## Generate Certificates by script
Before you call this terraform module, you should run the script for import root certificates for VPN Authentication.

Example of usage :

```
    $ ./scripts/generate_certs.sh vpn-domain myvpnuser
```
This certificate script is generating root-ca and certificate for your users.You can enable or disable root-ca function on script easily.

## Module Call

```
module "vpn_client" {
    dns_servers = ["1.1.1.1"]
    subnet_list = ["sub-123", "sub-124"]
    is_split_tunnel = false
}
```

## Parameters : 

* <b>is_split_tunnel</b> : If you set false, the split_tunneling property will disable and your all traffic even vpn external will tunneling  
* <b>subnet_list</b> : List of the subnets that containing where you want to  route your traffic
* <b>client_cidr_block</b> : CIDR block for setting internal IP for clients
* <b>enable_logs</b> : If you set false, disable logging of your vpn actions