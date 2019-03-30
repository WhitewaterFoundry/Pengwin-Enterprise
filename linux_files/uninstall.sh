#!/bin/bash

function uninstall_vcxsrv()
{
# Stop vcxsrv if running
if cmd.exe /C tasklist | grep -Fq 'vcxsrv.exe' ; then
	echo "vcxsrv.exe running. Killing process..."
	cmd.exe /C taskkill /IM 'vcxsrv.exe' /F
fi

# Remove .vcxsrv
echo "Removing ${Home}/.vcxsrv folder"
sudo rm -rf "${Home}/.vcxsrv"

# Remove vcxsrv.sh
echo "Removing /etc/profile.d/vcxsrv.sh"
sudo rm -f /etc/profile.d/vcxsrv.sh
}

function uninstall_pageant()
{
# Stop weasel-pageant, helper and pageant if running
helper_running=$(cmd.exe /C tasklist | grep -Fq 'helper.exe')
if cmd.exe /C tasklist | grep -Fq 'helper.exe' ; then
	echo "Weasel-pageant helper.exe running. Killing process..."
	cmd.exe /C taskkill /IM 'helper.exe' /F
fi

if ps | grep -Fq 'weasel-pageant' ; then
	echo "weasel-pageant running. Killing process..."
	pkill weasel-pageant
fi

if cmd.exe /C tasklist | grep -Fq 'pageant.exe' ; then
	echo "pageant.exe running. Killing process..."
	cmd.exe /C taskkill /IM 'pageant.exe' /F
fi

# Remove .pageant
echo "Removing ${Home}/.pageant"
sudo rm -rf "${Home}/.pageant"

# Remove weasel-pageant.sh
echo "Removing /etc/profile.d/pageant.sh"
sudo rm -f /etc/profile.d/pageant.sh

# Remove pageant startup registry key
echo "Removing pageant.exe startup registry key"
cat << EOF >> "${TMPDIR}/Uninstall.reg"
Windows Registry Editor Version 5.00
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\Pageant]
"Pageant"=-
EOF
cp "${TMPDIR}/Uninstall.reg" "$HomeDrive$(cmd.exe /C 'echo %TEMP%' 2>&1 | tr -d '\r' | sed 's|\\|\/|g' | sed 's|.\:||g')"
cmd.exe /C "Reg import %TEMP%\Uninstall.reg"
}

function main_uninstall()
{
# Get required paths
echo "Getting required application paths"
TMPDIR=$(mktemp -d)
wHomeDrive="$(cmd.exe /C 'echo %HOMEDRIVE%' | tr -d '\r')"
HomeDrive="/mnt/$(echo "${wHomeDrive}" | sed 's|\:||g' | tr '[:upper:]' '[:lower:]')"
wHomePath="$(cmd.exe /C 'echo %HOMEPATH%' | tr -d '\r')"
HomePath="$(echo "${wHomePath}" | sed 's|\\|\/|g')"
wHome="$wHomeDrive$wHomePath"
Home="$HomeDrive$HomePath"

uninstall_vcxsrv
uninstall_pageant
sudo rm -rf "${TMPDIR}"
}

# Initial checks
if [[ "$EUID" == 0 ]] ; then
	echo "Please run as regular user (not root)."
	exit 1
fi

# Initial user prompt message
echo "Now running the Pengwin Enterprise integrations uninstaller."
echo "The integrations can be reinstalled by moving the script /opt/pengwin/firstrun.sh into /etc/profile.d/"
echo "While these integrations can be reinstalled, any other files you may have placed in these folders cannot be recovered."
echo -n "If you understand this and would like to continue type 'YES' (all capitals): "
read userprompt
if [[ $userprompt == "YES" ]] ; then
	main_uninstall
	echo "To reinstall these integrations, please move /opt/pengwin/firstrun.sh into /etc/profile.d/"
	echo "Then restart the shell."
else
	exit 0
fi
