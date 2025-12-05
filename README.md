# Pengwin Enterprise

**Pengwin Enterprise is an enterprise Linux solution for Windows Subsystem for Linux (WSL) that is compatible with mainstream enterprise Linux distributions such as Oracle Linux and Red Hat Enterprise Linux (RHEL).**

New and casual Linux users are strongly encouraged to obtain [Pengwin](https://github.com/WhitewaterFoundry/Pengwin) from the [Microsoft Store](https://afflnk.microsoft.com/c/1291904/433017/7593?u=https%3A%2F%2Fwww.microsoft.com%2Fp%2Fwlinux%2F9nv1gv1pxz6p) instead. Pengwin includes end user support and [several usability modifications and tools](https://github.com/WhitewaterFoundry/Pengwin#features), such as pengwin-setup, to improve the overall WSL experience for end users.

## Available Versions

| Version | Base Distribution | Status |
|---------|------------------|--------|
| Pengwin Enterprise 9 | Rocky Linux 9 | Current |
| Pengwin Enterprise 8 | Rocky Linux 8 | Maintained |
| Pengwin Enterprise 7 | Scientific Linux 7 | Legacy |

## For Enterprise

**Pengwin Enterprise allows businesses, education, government, and other organizations to deploy a secure, reliable, and familiar Linux distribution on Windows Subsystem for Linux on Windows 10/11.**

**Pengwin Enterprise was designed to be highly adaptable for secure enterprise environments and is compatible with the mainstream enterprise Linux vendor distribution and other derivatives.**

**Custom builds of Pengwin Enterprise can be configured using standard Kickstart files to use internal package repositories and leverage other mainstream enterprise Linux vendor distribution security features.**

Businesses and other organizations who wish to license Pengwin Enterprise, develop a custom build for their specific needs, and receive ongoing support for Pengwin Enterprise should [e-mail us](mailto:enterprise@whitewaterfoundry.com) or visit [our website](https://www.whitewaterfoundry.com/pengwin-enterprise) for advice, details, and a quote.

There are several approaches to deploying Pengwin Enterprise on existing Windows 10/11 networks and Whitewater Foundry will work with your business or organization to develop a deployment, security, and support solution:

- [Microsoft Store for Business and Education](https://docs.microsoft.com/en-us/microsoft-store/microsoft-store-for-business-overview)
- [Microsoft Intune](https://docs.microsoft.com/en-us/intune/apps-windows-10-app-deploy)
- [SCCM](https://docs.microsoft.com/en-us/sccm/apps/deploy-use/deploy-applications)
- [App Installer](https://docs.microsoft.com/en-us/sccm/apps/deploy-use/deploy-applications)
- [Sideload](https://docs.microsoft.com/en-us/windows/application-management/sideload-apps-in-windows-10)

## Microsoft Store Build

**Pengwin Enterprise is provided on the Microsoft Store on a self-support basis for advanced individual end users who simply need an enterprise compatible WSL distro. It adheres very closely to mainstream enterprise Linux defaults.**

The Pengwin Enterprise 9 build provided on the Microsoft Store is derived from [Rocky Linux](https://rockylinux.org/), a community enterprise operating system designed to be 100% bug-for-bug compatible with Red Hat Enterprise Linux.

### What's Included in Microsoft Store Version

- Rocky Linux 9.x base system
- Systemd support (enabled by default)
- Windows Terminal integration with custom profile
- WSL utilities and enhancements
- Access to Rocky Linux package repositories
- Graphics support with Mesa

### What's NOT Included in Microsoft Store Version

- **Red Hat Enterprise Linux (RHEL) packages** - The Microsoft Store version uses Rocky Linux repositories, not RHEL
- **pengwin-setup** - This tool is only available in the standard [Pengwin](https://github.com/WhitewaterFoundry/Pengwin) distribution
- **Dedicated end user support** - Self-support only for Microsoft Store users
- **WSL usability features** found in Pengwin

## Frequently Asked Questions

### How do I get RHEL packages / convert to Red Hat?

The Microsoft Store version of Pengwin Enterprise uses Rocky Linux, which is RHEL-compatible but not RHEL itself. **To use actual RHEL packages, you need:**

1. **A Red Hat Enterprise Linux subscription** from Red Hat
2. **A custom Pengwin Enterprise deployment** from Whitewater Foundry

Contact [enterprise@whitewaterfoundry.com](mailto:enterprise@whitewaterfoundry.com) to discuss a custom build that connects to your organization's RHEL subscription and internal repositories.

**Note:** You cannot simply "convert" the Microsoft Store version to use RHEL packages. A proper RHEL integration requires a custom enterprise deployment.

### Is there pengwin-setup for Pengwin Enterprise?

**No.** The `pengwin-setup` tool is exclusive to the standard [Pengwin](https://github.com/WhitewaterFoundry/Pengwin) distribution and is not available in Pengwin Enterprise.

Pengwin Enterprise is designed for enterprise environments where system configuration is typically managed by IT administrators using standard enterprise Linux tools and methods. If you need the user-friendly setup experience provided by pengwin-setup, please consider using [Pengwin](https://github.com/WhitewaterFoundry/Pengwin) instead.

### Can I sell/distribute Pengwin Enterprise for commercial purposes?

**For the Microsoft Store version:** The Microsoft Store version is intended for demonstration purposes and personal use only. Commercial redistribution is not permitted without a license agreement.

**For commercial use:** Businesses and organizations requiring commercial licensing should contact Whitewater Foundry:

- Email: [enterprise@whitewaterfoundry.com](mailto:enterprise@whitewaterfoundry.com)
- Website: [whitewaterfoundry.com/pengwin-enterprise](https://www.whitewaterfoundry.com/pengwin-enterprise)

Whitewater Foundry can provide:
- Commercial licensing agreements
- Custom builds tailored to your organization
- Integration with your existing RHEL subscriptions
- Ongoing support contracts
- Volume licensing for large deployments

### How do I update Pengwin Enterprise 9?

Run the following commands in your Pengwin Enterprise terminal:

```bash
sudo dnf update
```

Or use the provided update script:

```bash
update.sh
```

## Documentation

### Pengwin Enterprise 9 (Rocky Linux 9 based)

- [Rocky Linux 9 Documentation](https://docs.rockylinux.org/)
- [Red Hat Enterprise Linux 9 Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/) - Compatible with Pengwin Enterprise 9
- [DNF Package Manager Documentation](https://dnf.readthedocs.io/)
- [Man page for dnf](https://man7.org/linux/man-pages/man8/dnf.8.html) - Guide for the dnf package manager

### Pengwin Enterprise 8 (Rocky Linux 8 based)

- [Rocky Linux 8 Documentation](https://docs.rockylinux.org/)
- [Red Hat Enterprise Linux 8 Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/) - Compatible with Pengwin Enterprise 8

### Pengwin Enterprise 7 (Scientific Linux 7 based - Legacy)

- [Red Hat Enterprise Linux 7 Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/)
- [Man page for yum](http://man7.org/linux/man-pages/man8/yum.8.html) - Guide for the yum package manager

### General WSL Resources

- [Troubleshooting Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting) - Solving common problems when installing WSL distros on Windows from Microsoft
- [Awesome WSL](https://github.com/sirredbeard/Awesome-WSL) - An Awesome collection of Windows Subsystem for Linux (WSL) information, distributions, and tools

## Support

Pengwin Enterprise is provided on the Microsoft Store for individual users on a self-support basis. [Basic troubleshooting](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting) will solve many problems. You may also [open an issue](https://github.com/WhitewaterFoundry/Pengwin-Enterprise/issues) on our GitHub for community support.

Businesses and other organizations who would like to receive professional ongoing support should [e-mail us](mailto:enterprise@whitewaterfoundry.com) or visit [our website](https://www.whitewaterfoundry.com/pengwin-enterprise).

## About

Whitewater Foundry, Ltd. Co. is an open-source startup that created Pengwin, the first Linux distribution designed for Windows Subsystem for Linux. Pengwin has since become a top developer tool on the Microsoft Store and Whitewater Foundry, Ltd. Co. has grown to a worldwide team. Pengwin Enterprise grew out of demand for a mainstream enterprise Linux vendor distribution on WSL from enterprise clients.

Whitewater Foundry is a Microsoft Partner, Red Hat Business Partner, and licensee in the Open Innovation Network.

[whitewaterfoundry.com](https://www.whitewaterfoundry.com/pengwin-enterprise)<br>
[enterprise@whitewaterfoundry.com](mailto:enterprise@whitewaterfoundry.com)

## Legal

**Pengwin Enterprise is not endorsed by or affiliated with Rocky Linux, Scientific Linux, Fermi National Accelerator Laboratory, the United States Department of Energy, the CentOS Project®, Microsoft®, or Red Hat, Inc.**

See [LICENSE.md](LICENSE.md) for important information on trademarks, copyright, patents, and software licensing.

See [BUILDING.md](BUILDING.md) for steps on how to build Pengwin Enterprise from source.
