set -e

#declare variables
ORIGINDIR=$(pwd)
BUILDDIR=$(mktemp -d)

#enterprise boot ISO
BOOTISO="/root/rhel-workstation-7.7-x86_64-dvd.iso"

#rhel kickstart file
KSFILE="/root/Pengwin-Enterprise/rhel-7.ks"

#make sure we are up to date
sudo yum update

#get livemedia-creator dependencies
sudo yum install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

#restart libvirtd for good measure
sudo systemctl restart libvirtd

#build intermediary rootfs tar
sudo livemedia-creator --make-tar --iso=$BOOTISO --image-name=install.tar.xz --ks=$KSFILE --releasever "7"

#open up the tar into our build directory
tar -xvf /var/tmp/install.tar.xz -C $BUILDDIR

#copy some custom files into our build directory 
sudo cp $ORIGINDIR/linux_files/wsl.conf $BUILDDIR/etc/wsl.conf
sudo cp $ORIGINDIR/linux_files/local.conf $BUILDDIR/etc/local.conf
sudo cp $ORIGINDIR/linux_files/DB_CONFIG $BUILDDIR/var/lib/rpm/

#set some environmental variables in our build directory
sudo bash -c "echo 'export DISPLAY=:0' >> $BUILDDIR/etc/profile.d/wsl.sh"
sudo bash -c "echo 'export LIBGL_ALWAYS_INDIRECT=1' >> $BUILDDIR/etc/profile.d/wsl.sh"
sudo bash -c "echo 'export NO_AT_BRIDGE=1' >> $BUILDDIR/etc/profile.d/wsl.sh"
sudo bash -c "echo 'export TERM=st-256color' >> $BUILDDIR/etc/profile.d/wsl.sh"

#re-build our tar image
cd $BUILDDIR
tar --ignore-failed-read -czvf $ORIGINDIR/install.tar.gz *

#go home
#cd $ORIGINDIR

#clean up
sudo rm -r $BUILDDIR