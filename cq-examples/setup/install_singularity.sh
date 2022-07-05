#!/bin/bash

# According to https://sylabs.io/guides/3.0/user-guide/installation.html

oldcwd=`pwd`

cd /tmp

# Install dependencies for singularity

sudo apt-get update && sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    pkg-config \
    cryptsetup

# Install go

sudo rm -rf /usr/local/go

export VERSION=1.16.7 OS=linux ARCH=amd64 && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz

echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc 
    
export GOPATH=${HOME}/go
export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin

# Checkout and install singularity

git clone https://github.com/sylabs/singularity.git
cd singularity
git checkout v3.8.1

./mconfig 
make -C builddir
sudo make -C ./builddir install

cd ${oldcwd}
