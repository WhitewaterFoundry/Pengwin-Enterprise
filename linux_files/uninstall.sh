#!/bin/bash

# Get required paths read
wHomeDrive="$(cmd.exe /C 'echo %HOMEDRIVE%' | tr -d '\r')"
HomeDrive="/mnt/$(echo "${wHomeDrive}" | sed 's|\:||g' | tr '[:upper:]' '[:lower:]')"
wHomePath="$(cmd.exe /C 'echo %HOMEPATH%' | tr -d '\r')"
HomePath="$(echo "${wHomePath}" | sed 's|\\|\/|g')"

# Stop and remove vcxsrv

# Stop and remove weasel-pageant & pageant integration

# Remove pageant startup registry key
echo "Removing pageant.exe startup registry key"
TEMPDIR=$(mktemp -d)
cat << EOF >> "${TMPDIR}/Uninstall.reg"
[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\Pageant]
EOF
cp "${TMPDIR}/Uninstall.reg" "$HomeDrive$(cmd.exe /C 'echo %TEMP%' 2>&1 | tr -d '\r' | sed 's|\\|\/|g' | sed 's|.\:||g')"
