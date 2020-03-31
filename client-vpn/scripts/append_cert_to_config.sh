#!/usr/bin/env bash

CERT=$(cat certs/client1.daas.kloia.vpn.crt)
KEY=$(cat certs/client1.daas.kloia.vpn.key)

sed -i '' "s/reneg-sec 0/ /g" client-config.ovpn
{
cat<<EOF >> client-config.ovpn

<cert>
${CERT}
</cert>
<key>
${KEY}
</key>

reneg-sec 0
EOF
}
