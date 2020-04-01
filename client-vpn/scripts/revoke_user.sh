#!/bin/bash
CLIENT_VPN_NAME=$1
AWS_REGION=$2
USER=$3

if [ -z "$USER" ]
then
    echo "Please specify a user usage : ./revoke_user VPN_ID REGION USER"
else
    echo "$USER is revoking"
fi

revoke_user(){

    
       
    pushd easy-rsa/easyrsa3
        ./easyrsa revoke ${USER}
        ./easyrsa gen-crl
        aws ec2 import-client-vpn-client-certificate-revocation-list --certificate-revocation-list file://pki/crl.pem --client-vpn-endpoint-id ${CLIENT_VPN_NAME} --region ${AWS_REGION}
    popd

}