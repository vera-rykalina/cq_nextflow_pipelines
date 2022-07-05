#!/bin/bash

oldcwd=`pwd`

sudo apt-get update
sudo apt-get install -y default-jre curl graphviz
mkdir ~/nextflow
cd ~/nextflow
curl -s https://get.nextflow.io | bash
echo 'export PATH=${PATH}:~/nextflow' >> ~/.bashrc
export PATH=${PATH}:~/nextflow

cd ${oldcwd} 
