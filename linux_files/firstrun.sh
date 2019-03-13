#!/bin/bash

wHomeWinPath=$(cmd.exe /c 'echo %HOMEDRIVE%%HOMEPATH%' 2>&1 | tr -d '\r')
wHome=$(wslpath -u "${wHomeWinPath}")

echo "Updating packages"
yum update

echo "Upgrading packages"
yum upgrade

echo "Installing Pageant"
mkdir ${wHome}/.pageant
cp /opt/pageant/* ${wHome}/.pageant

echo "Configuring Pageant Integration"
string = "eval $(" + ${wHome} + "/.pageant/weasel-pageant -r)"
echo "#!/bin/bash" > /etc/profile.d/pageant.sh
echo $string > /etc/profile.d/pageant.sh

echo "Installing VcXsrv"
mkdir ${wHome}/.vcxsrv
cp /opt/vcxsrv/vcxsrv-installer.exe ${wHome}/.vcxsrv/vcxsrv-installer.exe

echo "Removing this script"
mv /etc/profile.d/firstrun.sh /opt/firstrun.sh"
