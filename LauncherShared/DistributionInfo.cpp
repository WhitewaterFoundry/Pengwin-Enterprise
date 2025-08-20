//
//    Copyright (C) Microsoft.  All rights reserved.
// Licensed under the terms described in the LICENSE file in the root of this project.
//

#include "stdafx.h"

void RunProcess(LPWSTR cmdline)
{
    // additional information
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;

    // set the size of the structures
    ZeroMemory(&si, sizeof si);
    si.cb = sizeof si;
    ZeroMemory(&pi, sizeof pi);

    // start the program up
    CreateProcessW
    (
        nullptr, // the path
        cmdline, // Command line
        nullptr, // Process handle not inheritable
        nullptr, // Thread handle not inheritable
        FALSE, // Set handle inheritance to FALSE
        0, // Opens file in a separate console
        nullptr, // Use parent's environment block
        nullptr, // Use parent's starting directory
        &si, // Pointer to STARTUPINFO structure
        &pi // Pointer to PROCESS_INFORMATION structure
    );

    // Wait until child process exits.
    WaitForSingleObject(pi.hProcess, INFINITE);

    // Close process and thread handles.
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
}

void DistributionInfo::ChangeDefaultUserInWslConf(std::wstring_view userName)
{
    DWORD exitCode;
    wchar_t buff[255];
    _swprintf_p(buff, _countof(buff),
                L"wsl.exe -d %1$s -u root -- if [ $(grep -c \"\\[user\\]\" /etc/wsl.conf) -eq \"0\" ]; then echo -e \"\\n[user]\\ndefault=%2$s\">>/etc/wsl.conf; else sed -i \"s/\\(default=\\)\\(.*\\)/\\1%2$s/\" /etc/wsl.conf ; fi",
                Name.c_str(), std::wstring(userName).c_str());

    RunProcess(buff);
}

#ifdef VERSIONX

void RestorePreviousHome(const std::wstring_view userName, const BOOL previousHome)
{
    DWORD exitCode;
    if (previousHome)
    {
        std::wstring commandLine = L"mv /home/";
        commandLine += userName;
        commandLine += L" /home/userhome";
        g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
    }
}

bool MovePreviousHome(const std::wstring_view userName, BOOL& previousHome)
{
    previousHome = false;
    DWORD exitCode;

    std::wstring commandLine = L"test -d /home/userhome";
    // ReSharper disable once CppTooWideScopeInitStatement
    HRESULT hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
    if (FAILED(hr))
    {
        return false;
    }

    if (exitCode == 0)
    {
        previousHome = true;
        commandLine = L"mv /home/userhome /home/";
        commandLine += userName;
        hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
        if (FAILED(hr))
        {
            return false;
        }
    }
    return true;
}

#endif

bool DistributionInfo::CreateUser(std::wstring_view userName)
{
    DWORD exitCode;
    std::wstring commandLine = L"";

#ifdef VERSIONX
    BOOL previousHome;
    if (!MovePreviousHome(userName, previousHome)) {
        return false;
    }
#endif


    // Create the user account.
    commandLine = L"/usr/sbin/useradd -m ";
    commandLine += userName;
    HRESULT hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
    if (FAILED(hr) || exitCode != 0)
    {
#ifdef VERSIONX
        RestorePreviousHome(userName, previousHome);
#endif

        return false;
    }

    // Add the user account to any relevant groups.
    commandLine = L"/usr/sbin/usermod -aG adm,cdrom,wheel,video,wsl-video,render ";
    commandLine += userName;
    hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
    if (FAILED(hr) || exitCode != 0)
    {
        // Delete the user if the group add command failed.
        commandLine = L"/usr/sbin/userdel ";
        commandLine += userName;
        g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);

#ifdef VERSIONX
        RestorePreviousHome(userName, previousHome);
#endif

        return false;
    }

    // Set the password for the user
    commandLine = L"/usr/bin/passwd ";
    commandLine += userName;
    hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);

    if (FAILED(hr) || exitCode != 0)
    {
        // Delete the user if the set password failed.
        commandLine = L"/usr/sbin/userdel ";
        commandLine += userName;
        g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);

#ifdef VERSIONX
        RestorePreviousHome(userName, previousHome);
#endif

        return false;
    }

    return true;
}

bool DistributionInfo::SetRootPassword()
{
    DWORD exitCode;
    std::wstring commandLine = L"/usr/bin/passwd ";
    commandLine += L"root";
    const HRESULT hr = g_wslApi.WslLaunchInteractive(commandLine.c_str(), true, &exitCode);
    if (FAILED(hr) || exitCode != 0)
    {
        return false;
    }
    return true;
}

ULONG DistributionInfo::QueryUid(std::wstring_view userName)
{
    // Create a pipe to read the output of the launched process.
    HANDLE readPipe;
    HANDLE writePipe;
    SECURITY_ATTRIBUTES sa{sizeof sa, nullptr, true};
    ULONG uid = UID_INVALID;
    if (CreatePipe(&readPipe, &writePipe, &sa, 0))
    {
        // Query the UID of the supplied username.
        std::wstring command = L"/usr/bin/id -u ";
        command += userName;
        int returnValue = 0;
        HANDLE child;
        HRESULT hr = g_wslApi.WslLaunch(command.c_str(), true, GetStdHandle(STD_INPUT_HANDLE), writePipe,
                                        GetStdHandle(STD_ERROR_HANDLE), &child);
        if (SUCCEEDED(hr))
        {
            // Wait for the child to exit and ensure process exited successfully.
            WaitForSingleObject(child, INFINITE);
            DWORD exitCode;
            if (GetExitCodeProcess(child, &exitCode) == false || exitCode != 0)
            {
                hr = E_INVALIDARG;
            }

            CloseHandle(child);
            if (SUCCEEDED(hr))
            {
                char buffer[64];
                DWORD bytesRead;

                // Read the output of the command from the pipe and convert to a UID.
                if (ReadFile(readPipe, buffer, sizeof buffer - 1, &bytesRead, nullptr))
                {
                    buffer[bytesRead] = ANSI_NULL;
                    try
                    {
                        uid = std::stoul(buffer, nullptr, 10);
                    }
                    catch (...)
                    {
                    }
                }
            }
        }

        CloseHandle(readPipe);
        CloseHandle(writePipe);
    }

    return uid;
}
