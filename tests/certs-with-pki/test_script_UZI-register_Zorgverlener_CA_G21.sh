
I_NAMESPACE="intermediate_private_services_ca"
NAMESPACE="intermediate_UZI-register_Zorgverlener_CA_G21"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Private Services CA - G42" \
    -subj "/C=NL/O=CIBG/OID=NTRNL-50000535/CN=UZI-register Zorgverlener CA G21" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr || exit 1

openssl req -noout -text -in ${NAMESPACE}.csr


cat > ${NAMESPACE}.config <<End-of-message
[v3_intermediate_uzi]
basicConstraints = CA:TRUE,pathlen:0
keyUsage = critical,keyCertSign,cRLSign
certificatePolicies=1.3.3.7, 2.16.528.1.1003.1.2.8.4, 2.16.528.1.1003.1.2.8.5, @polselect

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[polselect]
policyIdentifier = 2.16.528.1.1003.1.2.8.6
CPS.1=https://example.org
End-of-message


openssl x509 -req \
    -in ${NAMESPACE}.csr \
    -CA ${I_NAMESPACE}.pem \
    -CAkey ${I_NAMESPACE}.key \
    -CAcreateserial \
    -days 898 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions v3_intermediate_uzi \
    -extfile ${NAMESPACE}.config \
    -out ${NAMESPACE}.pem || exit 1


openssl x509 -noout -text -in ${NAMESPACE}.pem
