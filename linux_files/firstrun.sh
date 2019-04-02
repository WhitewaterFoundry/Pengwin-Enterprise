#!/bin/bash

echo "Executing firstrun.sh script"

echo "Getting required application paths"
TMPDIR=$(mktemp -d)
wHomeDrive="$(cmd.exe /C 'echo %HOMEDRIVE%' | tr -d '\r')"
HomeDrive="/mnt/$(echo "${wHomeDrive}" | sed 's|\:||g' | tr '[:upper:]' '[:lower:]')"
wHomePath="$(cmd.exe /C 'echo %HOMEPATH%' | tr -d '\r')"
HomePath="$(echo "${wHomePath}" | sed 's|\\|\/|g')"
wHome="$wHomeDrive$wHomePath"
Home="$HomeDrive$HomePath"

# Add wslu repository and install wslu
# echo "Downloading and installing wslu repository"
# curl -L https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh -o "${TMPDIR}/script.sh" > /dev/null 2>&1
# sudo bash "${TMPDIR}/script.sh"

# echo "Updating repositories"
# sudo yum update
# echo "Upgrading packages"
# sudo yum upgrade -y
# echo "Installing wslu"
# sudo yum install wslu -y

# Install Putty's Pageant and weasel-pageant
if [[ ! -d "${Home}/.pageant"  ]] ; then
	echo "Installing Pageant (with weasel-pageant WSL integration) to ${Home}/.pageant"
	mkdir "${Home}/.pageant"
	cp /opt/pageant/* "${Home}/.pageant"
	chmod +x "${Home}/.pageant/weasel-pageant"
	chmod +x "${Home}/.pageant/helper.exe"
else
        echo "${Home}/.pageant already exists, leaving in place."
        echo "To reinstall pageant and other features, run /opt/pengwin/uninstall.sh then move /opt/pengwin/firstrun.sh to /etc/profile.d/"
fi

# Add Pageant startup registry entry
echo "Configuring Pageant to execute on startup"
wHomeRegEntry="$(echo $wHome | sed 's|\\|\\\\|g')"
cat << EOF >> "${TMPDIR}/Install.reg"
Windows Registry Editor Version 5.00
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]
"Pageant"="${wHomeRegEntry}\\\\.pageant\\\\pageant.exe"
EOF
cp "${TMPDIR}/Install.reg" "$HomeDrive$(cmd.exe /C 'echo %TEMP%' 2>&1 | tr -d '\r' | sed 's|\\|\/|g' | sed 's|.\:||g')"
cmd.exe /C "Reg import %TEMP%\Install.reg"
rm -rf "${TMPDIR}"

# Add profile.d start script for weasel-pageant
# NOTE: putting eval in a string like this is necessary to avoid bash executing it during
# 	running of firstrun.sh
echo "Configuring weasel-pageant WSL integration"
string="eval \$(\""${Home}/.pageant/weasel-pageant"\" -r)"
sudo bash -c 'cat > /etc/profile.d/pageant.sh' << EOF
#!/bin/bash
$string
EOF

# Unzip vcxsrv to user's directory
if [[ ! -d "${Home}/.vcxsrv"  ]] ; then
	echo "Installing vcxsrv to ${Home}/.vcxsrv"
	mkdir "${Home}/.vcxsrv"
	unzip -q /opt/vcxsrv/vcxsrv.zip -d "${Home}/.vcxsrv"
else
	echo "${Home}/.vcxsrv already exists, leaving in place."
	echo "To reinstall vcxsrv and other features, run /opt/pengwin/uninstall.sh then move /opt/pengwin/firstrun.sh to /etc/profile.d/"
fi

# Add profile.d start script for vcxsrv
echo "Configuring vcxsrv integration"
sudo bash -c 'cat > /etc/profile.d/vcxsrv.sh' << EOF
#!/bin/bash
cmd.exe /C '$wHome\.vcxsrv\vcxsrv.exe' :0 -silent-dup-error -multiwindow &> /dev/null &
disown
EOF

# Move firstrun.sh out of profile.d to /opt/pengwin
echo "Removing this script and backing up to /opt/pengwin/firstrun.sh"
sudo mkdir -p /opt/pengwin
sudo mv /etc/profile.d/firstrun.sh /opt/pengwin/firstrun.sh

# Restart shell
clear -x
echo "firstrun.sh complete, launching integrations and restarting shell..."
cmd.exe /C "$wHome\.pageant\pageant.exe" &> /dev/null &
disown
exec bash --login
