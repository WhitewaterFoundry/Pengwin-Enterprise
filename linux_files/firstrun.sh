#!/bin/bash

echo "Downloading and installing wslu repository"
curl -L https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh > /dev/null 2>&1 | sudo bash

echo "Updating repositories"
sudo yum update

echo "Upgrading packages"
sudo yum upgrade -y

echo "Installing wslu"
sudo yum install wslu -y

echo "Getting required application paths"
wHomeWinPath=$(cmd.exe /c 'echo %HOMEDRIVE%%HOMEPATH%' 2>&1 | tr -d '\r')
echo "wHomeWinPath = ${wHomeWinPath}"
wHome=$(wslpath -u "${wHomeWinPath}")
echo "wHome = ${wHome}"

echo "Installing Pageant to ${wHome}/.pageant"
mkdir "${wHome}/.pageant"
cp /opt/pageant/* "${wHome}/.pageant"
chmod +x "${wHome}/.pageant/weasel-pageant"

echo "Configuring Pageant Integration"
string="eval \$(\""${wHome}/.pageant/weasel-pageant"\" -r --helper \"${wHome}\")"
echo "#!/bin/bash" | sudo tee -a /etc/profile.d/pageant.sh
echo $string | sudo tee -a /etc/profile.d/pageant.sh

echo "Installing VcXsrv to ${wHome}/.vcxsrv"
mkdir "${wHome}/.vcxsrv"
cp /opt/vcxsrv/vcxsrv-installer.exe "${wHome}/.vcxsrv/vcxsrv-installer.exe"

echo "Removing this script"
sudo mkdir /opt/pengwin
sudo mv /etc/profile.d/firstrun.sh /opt/pengwin/firstrun.sh
