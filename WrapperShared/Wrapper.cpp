// FedoraRemixW.cpp : Defines the entry point for the application.
//

#include "framework.h"
#include <PathCch.h>
#include <iostream>

using namespace std;

#ifdef VERSION7
constexpr auto EXE_PATH = L"DistroLauncher";
constexpr auto EXE_NAME = L"WLE.exe";
#elif VERSION8
constexpr auto EXE_PATH = L"Launcher8";
constexpr auto EXE_NAME = L"PengwinEnterprise8.exe";
#endif

#ifdef SYSTEMD
constexpr auto EXE_PARAMETER = L" -s";
#else
constexpr auto EXE_PARAMETER = L" ";
#endif

void RunProcess(LPWSTR cmdline)
{
    // additional information
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;

    // set the size of the structures
    ZeroMemory(&si, sizeof si);
    si.cb = sizeof si;
    ZeroMemory(&pi, sizeof pi);

    si.dwFlags = STARTF_USESHOWWINDOW;

#ifdef NOWINDOW
    si.wShowWindow = SW_HIDE;
#else
    si.wShowWindow = SW_NORMAL;
#endif

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
    //WaitForSingleObject(pi.hProcess, INFINITE);

    // Close process and thread handles.
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
}

int APIENTRY wWinMain(_In_ HINSTANCE hInstance,
                      _In_opt_ HINSTANCE hPrevInstance,
                      _In_ LPWSTR lpCmdLine,
                      _In_ int nCmdShow)
{
    wchar_t buff[1024];

    GetModuleFileNameW(nullptr,
                       buff, _countof(buff));

    PathCchRemoveFileSpec(buff, _countof(buff));
    PathCchRemoveFileSpec(buff, _countof(buff));
    PathCchAppendEx(buff, _countof(buff), EXE_PATH, PATHCCH_ALLOW_LONG_PATHS);
    PathCchAppendEx(buff, _countof(buff), EXE_NAME, PATHCCH_ALLOW_LONG_PATHS);

    wcscat_s(buff, _countof(buff), EXE_PARAMETER);
    wcscat_s(buff, _countof(buff), lpCmdLine);

    RunProcess(buff);

    return 0;
}
