# Step 1: Create a certificate authority
mkdir certs
rm -f certs/*
openssl genrsa -out certs/ca.key 4096
openssl req -x509 -new -nodes -key certs/ca.key -sha256 -days 1024 -out certs/ca.crt -subj "/C=US/ST=CA/O=Turbine Labs/CN=ca.com/emailAddress=admin@ca.com"
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) []:US
# State or Province Name (full name) []:CA
# Locality Name (eg, city) []:SF
# Organization Name (eg, company) []:Turbine Labs
# Organizational Unit Name (eg, section) []:Envoy Division
# Common Name (eg, fully qualified host name) []:example.com
# Email Address []:you@example.com

# Step 2: Create a domain key
openssl genrsa -out certs/server.key 2048
openssl genrsa -out certs/client.key 2048

# Step 3: Generate certificate signing requests for the proxies
openssl req -new -sha256 \
     -key certs/client.key \
     -subj "/C=US/ST=CA/O=Turbine Labs/CN=localhost,127.0.0.1,172.26.128.144,server.example.com" \
     -out certs/client.csr
openssl req -new -sha256 \
    -key certs/server.key \
    -subj "/C=US/ST=CA/O=Turbine Labs/CN=localhost,127.0.0.1,172.26.128.144,server.example.com" \
    -out certs/server.csr

# Step 4: Sign the proxy certificates
echo "subjectAltName=DNS.1:localhost,DNS.2:server.example.com,IP.1:127.0.0.1,IP.2:172.26.128.144" > extfile.cnf
openssl x509 -req \
     -in certs/client.csr \
     -CA certs/ca.crt \
     -CAkey certs/ca.key \
     -CAcreateserial \
     -extfile extfile.cnf \
     -out certs/client.crt \
     -days 500 \
     -sha256
openssl x509 -req \
    -in certs/server.csr \
    -CA certs/ca.crt \
    -CAkey certs/ca.key \
    -CAcreateserial \
    -extfile extfile.cnf \
    -out certs/server.crt \
    -days 500 \
    -sha256