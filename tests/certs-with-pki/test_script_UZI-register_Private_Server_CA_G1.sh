#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="private_services_ca_intermediate"
export NAMESPACE="UZI-register_Private_Server_CA_G1_intermediate"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=GBIC/organizationIdentifier=NTRNL-50000535/CN=UZI-register Private Server CA G1" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr || exit 1

echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


cat > ${NAMESPACE}.config <<End-of-message
[uzi_main]
basicConstraints = CA:TRUE,pathlen:0
keyUsage = critical,keyCertSign,cRLSign
certificatePolicies=1.3.3.7, 2.16.528.1.1003.1.2.8.4, 2.16.528.1.1003.1.2.8.5, @polselect

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[polselect]
policyIdentifier = 2.16.528.1.1003.1.2.8.6
CPS.1=https://example.org
End-of-message


# Assuming all variables are available
EXTENSION_MAIN="uzi_main"
CERT_DAYS=898
sign_certificate

display_certificate "${NAMESPACE}.pem"
