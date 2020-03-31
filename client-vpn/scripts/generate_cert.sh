#!/bin/bash


CLIENT_ID=$2
DOMAIN=$1
CERT_DIR="certs"


git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki
export EASYRSA_BATCH=1
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full $CLIENT_ID.$DOMAIN nopass
mkdir ../../$CERT_DIR
mv pki/ca.crt ../../$CERT_DIR/
mv pki/issued/server.crt ../../$CERT_DIR/
mv pki/private/server.key ../../$CERT_DIR/
mv pki/issued/$CLIENT_ID.$DOMAIN.crt ../../$CERT_DIR/
mv pki/private/$CLIENT_ID.$DOMAIN.key ../../$CERT_DIR/