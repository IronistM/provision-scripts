#Start with a dist upgrade
sudo apt dist-upgrade

# Get chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i ./google-chrome*.deb
sudo apt-get install -f

# dev (php, docker, git, node, bower, electron, composer)
sudo apt install -y \
  php php-curl php-mysql \
  docker.io \
  git \
  nodejs npm 
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g bower electron
wget https://getcomposer.org/installer
php installer
rm installer 
sudo mv composer.phar /usr/bin/composer
sudo gpasswd -a $USER docker
sudo service docker restart
sudo docker pull postgres # Get most used open source DB
sudo docker pull redash/redash # Get latest re:dash docker

# add-apt-repository
sudo apt-get install software-properties-common python-software-properties

# archive formats
sudo apt install unace  rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip

# GUI pour autoriser les sources non libres (canonical..)
sudo apt install software-properties-common
sudo apt install software-properties-gtk
sudo apt install ubuntu-restricted-extras

# libreoffice
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt update
sudo apt install libreoffice-gtk2 libreoffice-gnome

# java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt install oracle-java8-installer

# vlc
sudo apt install -y vlc

# atom
sudo add-apt-repository ppa:webupd8team/atom
sudo apt update && sudo apt install atom
# install add-ins with apm
apm install file-icons
apm install atom-beautify
apm install indent-guide-improved
apm install git-plus
apm install highlight-selected minimap minimap-highlight-selected minimap-find-and-replace
apm install pigments


# Get R (base) and a few dependencies for packages
sudo apt-get -y install r-base libapparmor1 libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo su - -c "R -e \"install.packages('tidyverse', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""

# Get R-Studio
sudo apt-get install gdebi-core
wget https://www.rstudio.org/download/latest/daily/desktop/ubuntu64/rstudio-latest-amd64.deb # latest as now()!
sudo gdebi rstudio-latest-amd64.deb

# Python's turn..
sudo apt-get -y install fastqc python-stdeb python-pip python-devcd
sudo apt-get -y install build-essentials
sudo pip install --upgrade pip
sudo pip install psutil
sudo pip install configobj
sudo apt-add-repository ppa:neufeldlab/ppa && sudo apt-get update && sudo apt-get -y install pandaseq

# remove elementary softwares
sudo apt purge epiphany-browser epiphany-browser-data
sudo apt purge midori-granite
sudo apt purge noise
sudo apt purge bluez
sudo apt purge modemmanager
sudo apt purge geary
sudo apt autoremove
sudo apt autoclean
