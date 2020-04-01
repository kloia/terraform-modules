#!/bin/bash

VPN_ADDR=$1
CLIENT_NAME=$2
BASE_PATH=$(pwd)


clone_easy_rsa(){
    cd $BASE_PATH
    git clone https://github.com/OpenVPN/easy-rsa.git
}

generate_root_ca(){
    cd $BASE_PATH


    if [ -d "$VPN_ADDR" ] 
    then
        echo "Directory $VPN_ADDR exists." 
    else
        echo "Creating directory $VPN_ADDR"
        mkdir -p $VPN_ADDR
    fi

    pushd easy-rsa/easyrsa3
        ./easyrsa init-pki
        ./easyrsa build-ca nopass
        ./easyrsa build-server-full $VPN_ADDR nopass
        cp pki/ca.crt $BASE_PATH/$VPN_ADDR/
        cp pki/issued/$VPN_ADDR.crt $BASE_PATH/$VPN_ADDR/
        cp pki/private/$VPN_ADDR.key $BASE_PATH/$VPN_ADDR/
    popd


}

generate_user_cert(){
    pushd easy-rsa/easyrsa3
        ./easyrsa build-client-full $CLIENT_NAME nopass
        cp pki/issued/$CLIENT_NAME.crt $BASE_PATH/$VPN_ADDR/
        cp pki/private/$CLIENT_NAME.key $BASE_PATH/$VPN_ADDR/
    popd
}


clone_easy_rsa
generate_root_ca
generate_user_cert