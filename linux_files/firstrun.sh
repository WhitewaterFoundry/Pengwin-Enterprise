#!/bin/bash

echo "Downloading and installing wslu repository"
curl -L https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh | bash

echo "Updating repositories"
yum update

echo "Upgrading packages"
yum upgrade -y

echo "Installing wslu"
yum install wslu -y

echo "Getting required application paths"
wHomeWinPath=$(cmd.exe /c 'echo %HOMEDRIVE%%HOMEPATH%' 2>&1 | tr -d '\r')
echo "wHomeWinPath = ${wHomeWinPath}"
wHome=$(wslpath -u "${wHomeWinPath}")
echo "wHome = ${wHome}"

echo "Installing Pageant to ${wHome}/.pageant"
mkdir ${wHome}/.pageant
cp /opt/pageant/* ${wHome}/.pageant

echo "Configuring Pageant Integration"
string = "eval $(" + ${wHome} + "/.pageant/weasel-pageant -r)"
echo "#!/bin/bash" > /etc/profile.d/pageant.sh
echo $string > /etc/profile.d/pageant.sh

echo "Installing VcXsrv to ${wHome}/.vcxsrv"
mkdir ${wHome}/.vcxsrv
cp /opt/vcxsrv/vcxsrv-installer.exe ${wHome}/.vcxsrv/vcxsrv-installer.exe

echo "Removing this script"
mv /etc/profile.d/firstrun.sh /opt/firstrun.sh"
