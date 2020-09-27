set -e

#declare variables
ORIGINDIR=$(pwd)
TMPDIR=$(mktemp -d)
BUILDDIR=$(mktemp -d)

#enterprise boot ISO
BOOTISO="/root/install.iso"

#enterprise Docker kickstart file
KSFILE="https://raw.githubusercontent.com/WhitewaterFoundry/sig-cloud-instance-build/master/docker/rhel-7.ks"

cd "$TMPDIR"

#make sure we are up to date
sudo yum -y update

#get livemedia-creator dependencies
sudo yum -y install libvirt lorax virt-install libvirt-daemon-config-network libvirt-daemon-kvm libvirt-daemon-driver-qemu

#restart libvirtd for good measure
sudo systemctl restart libvirtd

#download enterprise boot ISO
if [[ ! -f /tmp/install.iso ]] ; then
  cp "${BOOTISO}" /tmp/install.iso
fi
#download enterprise Docker kickstart file
curl $KSFILE -o install.ks

rm -f /var/tmp/install.tar.xz

#build intermediary rootfs tar
sudo livemedia-creator --make-tar --iso=/tmp/install.iso --image-name=install.tar.xz --ks=install.ks --releasever "7"

#open up the tar into our build directory
tar -xvf /var/tmp/install.tar.xz -C "${BUILDDIR}"

#copy some custom files into our build directory 
sudo cp "${ORIGINDIR}"/linux_files/wsl.conf "${BUILDDIR}"/etc/wsl.conf
sudo mkdir "${BUILDDIR}"/etc/fonts
sudo cp "${ORIGINDIR}"/linux_files/local.conf "${BUILDDIR}"/etc/fonts/local.conf
sudo cp "${ORIGINDIR}"/linux_files/DB_CONFIG "${BUILDDIR}"/var/lib/rpm/
sudo cp "${ORIGINDIR}"/linux_files/00-wle.sh "${BUILDDIR}"/etc/profile.d/
sudo cp "${ORIGINDIR}"/linux_files/upgrade.sh "${BUILDDIR}"/usr/local/bin/upgrade.sh
sudo chmod +x "${BUILDDIR}"/usr/local/bin/upgrade.sh

#re-build our tar image
cd "${BUILDDIR}"
tar --ignore-failed-read -czvf "${ORIGINDIR}"/x64/install.tar.gz *

#go home
cd "${ORIGINDIR}"

#clean up
sudo rm -r "${BUILDDIR}"
sudo rm -r "$TMPDIR"
sudo rm /tmp/install.iso
sudo rm /var/tmp/install.tar.xz
