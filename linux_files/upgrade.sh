#!/usr/bin/env bash

sha256sum /usr/local/bin/upgrade.sh >/tmp/sum.txt
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Pengwin-Enterprise/master/linux_files/upgrade.sh -o /usr/local/bin/upgrade.sh
sudo chmod +x /usr/local/bin/upgrade.sh
sha256sum -c /tmp/sum.txt

CHANGED=$?
rm -r /tmp/sum.txt

# the script has changed? run the newer one
if [ ${CHANGED} -eq 1 ]; then
  echo Running the updated script
  bash /usr/local/bin/upgrade.sh
  exit 0
fi

#enable wslu repo
sudo yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/ScientificLinux_7/home:wslutilities.repo
sudo yum -y update

# Update the release and main startup script files
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Pengwin-Enterprise/master/linux_files/00-wle.sh -o /etc/profile.d/00-wle.sh
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Pengwin-Enterprise/master/linux_files/os-release -o /etc/os-release

# Add local.conf to fonts
sudo curl -f https://raw.githubusercontent.com/WhitewaterFoundry/Pengwin-Enterprise/master/linux_files/local.conf -o /etc/fonts/local.conf
