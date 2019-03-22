#!/bin/bash

# Add wslu repository and install wslu
echo "Downloading and installing wslu repository"
curl -L https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh | sudo bash
echo "Updating repositories"
sudo yum update
echo "Upgrading packages"
sudo yum upgrade -y
echo "Installing wslu"
sudo yum install wslu -y

# Get required application paths
echo "Getting required application paths"
wHomeWinPath=$(cmd.exe /c 'echo %HOMEDRIVE%%HOMEPATH%' 2>&1 | tr -d '\r')
echo "wHomeWinPath = ${wHomeWinPath}"
wHome=$(wslpath -u "${wHomeWinPath}")
echo "wHome = ${wHome}"

# Install Putty's Pageant and weasel-pageant
echo "Installing Pageant (with weasel-pageant WSL integration) to ${wHome}/.pageant"
mkdir "${wHome}/.pageant"
cp /opt/pageant/* "${wHome}/.pageant"
chmod +x "${wHome}/.pageant/weasel-pageant"

# Add Pageant startup registry entry
echo "Configuring Pageant to execute on startup"
TMPDIR=$(mktemp -d)
cat << EOF >> "${TMPDIR}/Install.reg"
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]
@="Pageant startup"
"Pageant"="${wHomeWinPath}\\.pageant\\pageant.exe"
EOF
cp "${TMPDIR}/Install.reg" "$(cmd.exe /C 'echo %TEMP%' 2>&1 | tr -d '\r' | sed 's|\\|\/|g' | sed 's|C\:|\/mnt\/c|g')"
cmd.exe /C "Reg import %TEMP%\Install.reg"
rm -rf "${TMPDIR}"

# Add profile.d start script for weasel-pageant
echo "Configuring weasel-pageant WSL integration"
string="eval \$(\""${wHome}/.pageant/weasel-pageant"\" -r --helper \"${wHome}/.pageant\")"
sudo bash -c 'cat > /etc/profile.d/pageant.sh' << EOF
#!/bin/bash
$string
EOF

# Unzip vcxsrv to user's directory
echo "Installing vcxsrv to ${wHome}/.vcxsrv"
mkdir "${wHome}/.vcxsrv"
unzip /opt/vcxsrv/vcxsrv.zip -d "${wHome}/.vcxsrv" > /dev/null 2>&1

# Add profile.d start script for vcxsrv
echo "Configuring vcxsrv integration"
sudo bash -c 'cat > /etc/profile.d/vcxsrv.sh' << EOF
#!/bin/bash
'$wHome/.vcxsrv/vcxsrv.exe' :0 -silent-dup-error -multiwindow &> /dev/null &
disown
EOF

# Move firstrun.sh out of profile.d to /opt/pengwin
echo "Removing this script"
sudo mkdir /opt/pengwin
sudo mv /etc/profile.d/firstrun.sh /opt/pengwin/firstrun.sh
