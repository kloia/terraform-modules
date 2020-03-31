#!/usr/bin/env bash


CLIENT_ID=$3
CERT_DIR="certs"

git clone https://github.com/GOpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki
export EASYRSA_BATCH=1
./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full $CLIENT_ID.$2 nopass
mkdir ../../$CERT_DIR
mv pki/ca.crt ../../$CERT_DIR/
mv pki/issued/server.crt ../../$CERT_DIR/
mv pki/private/server.key ../../$CERT_DIR/
mv pki/issued/$CLIENT_ID.$2.crt ../../$CERT_DIR/
mv pki/private/$CLIENT_ID.$2.key ../../$CERT_DIR/