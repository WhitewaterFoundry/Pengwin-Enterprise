//
//    Copyright (C) Microsoft.  All rights reserved.
// Licensed under the terms described in the LICENSE file in the root of this project.
//

#pragma once

namespace DistributionInfo
{
    // The name of the distribution. This will be displayed to the user via
    // wslconfig.exe and in other places. It must conform to the following
    // regular expression: ^[a-zA-Z0-9._-]+$
    //
    // WARNING: This value must not change between versions of your app,
    // otherwise users upgrading from older versions will see launch failures.
#ifdef VERSION7
    const std::wstring Name = L"WLE";
#elif VERSION8
    const std::wstring Name = L"PengwinEnterprise8";
#elif VERSION9
    const std::wstring Name = L"PengwinEnterprise9";
#elif VERSIONX
    const std::wstring Name = L"PengwinEnterpriseX";
#endif

    // The title bar for the console window while the distribution is installing.
    const std::wstring WindowTitle = L"Pengwin Enterprise";

    // Set root user password
    bool SetRootPassword();

    // Create and configure a user account.
    bool CreateUser(std::wstring_view userName);

    // Query the UID of the user account.
    ULONG QueryUid(std::wstring_view userName);

    // Changes the default user in /etc/wsl.conf
    void ChangeDefaultUserInWslConf(std::wstring_view userName);
}
