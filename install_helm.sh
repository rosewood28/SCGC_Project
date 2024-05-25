#!/bin/bash

echo "Download Helm binary"
wget https://get.helm.sh/helm-v3.15.1-linux-amd64.tar.gz
wget https://get.helm.sh/helm-v3.15.1-linux-amd64.tar.gz.sha256sum

# Verify the checksum
sha256sum -c helm-v3.15.1-linux-amd64.tar.gz.sha256sum

# Check if the verification was succesful
if [ $? -eq 0 ]; then
    echo "Checksum verification passed."
    
    echo "Unpack the tar"
    tar -zxvf helm-v3.15.1-linux-amd64.tar.gz

    echo "Move the Helm binary to /usr/local/bin/helm"
    sudo mv linux-amd64/helm /usr/local/bin/helm

    echo "Clean the downloaded files"
    rm -rf linux-amd64 helm-v3.15.1-linux-amd64.tar.gz helm-v3.15.1-linux-amd64.tar.gz.sha256sum
    
    echo "Verify installation with helm version"
    helm version
    
    echo "Helm installation succesful."
else
    echo "Checksum verification failed."
    exit 1
fi
