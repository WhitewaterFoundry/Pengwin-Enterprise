For building steps, generally follow the Pengwin building guide [here](https://github.com/WhitewaterFoundry/Pengwin/blob/master/BUILDING.md).

.diff:

create-targz-x64.sh must be run on an existing enterprise Linux build instead of Debian.

The create-targz-x64.sh was moved to https://github.com/WhitewaterFoundry/pengwin-enterprise-rootfs-builds
Because the building process uses libvrtd and that is currently unsupported on WSL running create-targz-x64.sh on bare metal is required.
