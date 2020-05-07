# Documented here:
# https://access.redhat.com/documentation/en-us/red_hat_fuse/7.6/html-single/managing_fuse/index#fuse-console-generate-certificate-openshift4

oc get secrets/signing-key -n openshift-service-ca -o "jsonpath={.data['tls\.crt']}" | base64 --decode > ca.crt
oc get secrets/signing-key -n openshift-service-ca -o "jsonpath={.data['tls\.key']}" | base64 --decode > ca.key
openssl genrsa -out server.key 2048
cat <<EOT >> csr.conf
  [ req ]
  default_bits = 2048
  prompt = no
  default_md = sha256
  distinguished_name = dn

  [ dn ]
  CN = fuse-console.fuse.svc

  [ v3_ext ]
  authorityKeyIdentifier=keyid,issuer:always
  keyUsage=keyEncipherment,dataEncipherment,digitalSignature
  extendedKeyUsage=serverAuth,clientAuth
EOT

openssl req -new -key server.key -out server.csr -config csr.conf
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 10000 -extensions v3_ext -extfile csr.conf

oc create secret tls fuse76-console-tls-proxying --cert server.crt --key server.key -n seating-monitoring
