#!/bin/bash

echo "Downloading and installing wslu repository"
curl -L https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh | sudo bash

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
string="eval \$(\""${wHome}/.pageant/weasel-pageant"\" -r --helper \"${wHome}/.pageant\")"
sudo bash -c 'cat > /etc/profile.d/pageant.sh' << EOF
#!/bin/bash
$string
EOF

echo "Installing VcXsrv to ${wHome}/.vcxsrv"
mkdir "${wHome}/.vcxsrv"
unzip /opt/vcxsrv/vcxsrv.zip -d "${wHome}/.vcxsrv" > /dev/null 2>&1

echo "Configuring vcxsrv integration"
sudo bash -c 'cat > /etc/profile.d/vcxsrv.sh' << EOF
#!/bin/bash
'$wHome/.vcxsrv/vcxsrv.exe' :0 -silent-dup-error -multiwindow &> /dev/null &
disown
EOF

echo "Removing this script"
sudo mkdir /opt/pengwin
sudo mv /etc/profile.d/firstrun.sh /opt/pengwin/firstrun.sh
