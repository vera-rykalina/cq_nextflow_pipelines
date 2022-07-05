sudo apt install -y vim python2 r-base-core r-cran-tidyverse libclang-dev git ncbi-blast+ ncbi-tools-bin mafft seaview clustalw mlocate
mkdir -p tools
cd tools
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh
rm ./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda install pandas keras tensorflow numpy scipy spyder jupyter jupyterlab biopython
pip3 install biopandas
pip3 install pytest-workflow
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2021.09.2-382-amd64.deb
sudo dpkg --install rstudio-2021.09.2-382-amd64.deb
rm rstudio-2021.09.2-382-amd64.deb
wget --content-disposition https://go.microsoft.com/fwlink/?LinkID=760868
sudo dpkg --install code*.deb
rm code*.deb
wget --content-disposition https://atom.io/download/deb
sudo dpkg --install atom*.deb
rm atom*.deb
wget http://www.jalview.org/getdown/release/install4j/1.8/jalview-2_11_1_4-linux_x64-java_8.sh
bash ./jalview-2_11_1_4-linux_x64-java_8.sh
rm jalview-2_11_1_4-linux_x64-java_8.sh
