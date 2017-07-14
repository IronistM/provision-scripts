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
sudo npm install n -g
sudo n latest
sudo gpasswd -a $USER docker
sudo service docker restart


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

# latex
sudo apt install texlive-latex-base

# pandoc
sudo apt install pandoc

# vlc
sudo apt install -y vlc

# skype
wget https://repo.skype.com/latest/skypeforlinux-64.deb
sudo gdebi skypeforlinux-64.deb
rm skypeforlinux-64.deb

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

# google cloud SDK
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-146.0.0-linux-x86_64.tar.gz | tar xzf -
./google-cloud-sdk/install.sh

# spotify client
echo deb http://repository.spotify.com testing non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client

# Dropbox for elementary OS
# git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
# bash /tmp/elementary-dropbox/install.sh

# Apache Drill
wget http://apache.mirrors.hoobly.com/drill/drill-1.9.0/apache-drill-1.9.0.tar.gz | tar xzf -
rm apache-drill-1.9.0.tar.gz

# Get R (base) and a few dependencies for packages
sudo apt-get -y install r-base libapparmor1 libcurl4-gnutls-dev libxml2-dev libssl-dev
sudo su - -c "R -e \"install.packages('tidyverse', repos = 'http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('devtools', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"devtools::install_github('daattali/shinyjs')\""
sudo su - -c "R -e \"devtools::install_github('rstats-db/bigrquery')\""
sudo su - -c "R -e \"install.packages('rmarkdown', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('RCurl', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages(c('googleAuthR', 'shinyFiles', 'googleCloudStorageR', 'bigQueryR', 'gmailr', 'googleAnalyticsR'), repos='http://cran.rstudio.com/')\""

# Get R-Studio
sudo apt-get install gdebi-core
wget https://www.rstudio.org/download/latest/daily/desktop/ubuntu64/rstudio-latest-amd64.deb # latest as now()!
sudo gdebi rstudio-latest-amd64.deb

# Python's turn..
sudo apt-get -y install fastqc python-stdeb python-pip python-devcd
sudo apt-get -y install build-essentials
sudo pip install --upgrade pip # if needed let's update it
sudo pip install psutil
sudo pip install configobj
sudo apt-add-repository ppa:neufeldlab/ppa && sudo apt-get update && sudo apt-get -y install pandaseq

# Get git-standup
curl -L https://raw.githubusercontent.com/kamranahmedse/git-standup/master/installer.sh | sudo sh

# remove elementary softwares
#sudo apt purge epiphany-browser epiphany-browser-data
#sudo apt purge midori-granite
#sudo apt purge noise
#sudo apt purge bluez
#sudo apt purge modemmanager
#sudo apt purge geary
sudo apt autoremove
sudo apt autoclean
