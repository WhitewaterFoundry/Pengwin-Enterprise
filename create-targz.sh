#!/bin/sh

set -e

#declare variables
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)

BOOTISO="https://centos.mirror.constant.com/7.6.1810/os/x86_64/images/boot.iso"
KSFILE="https://raw.githubusercontent.com/CentOS/sig-cloud-instance-build/master/docker/centos-7-x86_64.ks"

#go to our temporary directory
cd $TMPDIR

#make sure we are up to date
sudo yum update

#get livemedia-creator dependencies
sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu unzip wget

#restart libvirtd for good measure
sudo systemctl restart libvirtd

#download enterprise boot ISO
sudo curl $BOOTISO -o /tmp/install.iso

#download enterprise Docker kickstart file
curl $KSFILE -o install.ks

#build intermediary rootfs tar
sudo livemedia-creator --make-tar --iso=/tmp/install.iso --image-name=install.tar.xz --ks=install.ks --releasever "7"

#open up the tar into our build directory
tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

#copy some custom WSL-related into our build directory 
sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
sudo cp $ORIGINDIR/linux_files/local.conf $BUILDDIR/etc/local.conf
sudo cp $ORIGINDIR/linux_files/DB_CONFIG $BUILDDIR/var/lib/rpm/DB_CONFIG
sudo cp $ORIGINDIR/linux_files/firstrun.sh $BUILDDIR/etc/profile.d/firstrun.sh

#copy pageant.exe to /opt/pageant
mkdir $BUILDDIR/opt/pageant
wget -P $BUILDDIR/opt/pageant "https://the.earth.li/~sgtatham/putty/latest/w64/pageant.exe"

#install epel repo (needed for pygpgme)
wget -P $BUILDDIR/tmp "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
sudo chroot $BUILDDIR yum -y install /tmp/epel-release-latest-7.noarch.rpm
sudo chroot $BUILDDIR yum update

#install wslutilities
wget -P $BUILDDIR/tmp "https://packagecloud.io/install/repositories/whitewaterfoundry/wslu/script.rpm.sh"
sudo chroot $BUILDDIR bash /tmp/script.rpm.sh
sudo chroot $BUILDDIR yum -y install wslu

#get weasel-pageant
wget https://github.com/vuori/weasel-pageant/releases/download/v1.3/weasel-pageant-1.3.zip
unzip weasel-pageant-1.3.zip
cp ./weasel-pageant-1.3/helper.exe $BUILDDIR/opt/pageant/
cp ./weasel-pageant-1.3/weasel-pageant $BUILDDIR/opt/pageant/

#get vcxsrv
mkdir $BUILDDIR/opt/vcxsrv
wget -P "vcxsrv-instsller.exe" "https://sourceforge.net/projects/vcxsrv/files/vcxsrv/1.20.1.4/vcxsrv-64.1.20.1.4.installer.exe/download"
cp vcxsrv-installer.exe $BUILDDIR/opt/vcxsrv/

#set some environmental variables
sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile.d/wsl.sh"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile.d/wsh.sh"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile.d/wsl.sh"

#re-build our tar image
cd $BUILDDIR
tar --ignore-failed-read -czvf $ORIGINDIR/install.tar.gz *

#go home
cd $ORIGINDIR

#clean up
sudo rm -r $BUILDDIR
sudo rm -r $TMPDIR
sudo rm /tmp/install.iso
sudo rm /var/tmp/install.tar.xz
