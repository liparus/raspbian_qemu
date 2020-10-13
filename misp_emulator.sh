#! /bin/bash

#
#
# Add MISP architecture to Raspbian Qemu ARM emulator script (raspi-qemu-setup.sh)
#
# Commands & guide from: https://markuta.com/how-to-build-a-mips-qemu-image-on-debian/


# set script colors
NC='\033[0m'		# No color
GREEN='\033[1;32m'
#BLUE='\033[1;34m'
#GRAY='\033[0;36m'
RED='\033[0;31m'


#***************
# MISP EMULATOR
#***************



# FUNCTIONS (Selections):
#------------------------


_install_package() {
	sudo apt-get install qemu-system-mips
}


_download_installer() {
	# Download installer (Malta)
	# NOTE: There are two versions Malta and Octeon.
	wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/initrd.gz
}

_download_kernel() {
	# Download Kernel
	# NOTE: versions might differ
	wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/vmlinux-4.19.0-10-4kc-malta
}


# ! NOTE: ADD VERIFY DOWNLOAD !
# shasum -a 256 initrd.gz vmlinux-4.19.0-10-4kc-malta
# ---------------------------------------------------

_create_image() {
	# Create an qcow2 format image with 2G of storage:
	qemu-img create -f qcow2 hda.img 2G
}

_install_debian_misp() {
	# Install Debian MIPS:
	qemu-system-mips -M malta \
  	k-m 256 -hda hda.img \
  	-kernel vmlinux-4.19.0-10-4kc-malta \
  	-initrd initrd.gz \
  	-append "console=ttyS0 nokaslr" \
  	-nographic
}


# ! NOTE: next step is graphical installation !
# ---------------------------------------------

_mount_bootpart() {
	# Mount the boot partition of the image file: 
	sudo modprobe nbd max_part=63
	sudo qemu-nbd -c /dev/nbd0 hda.img
	sudo mount /dev/nbd0p1 /mnt
}


# Copy a single file or the entire folder to the current directory:
cp -r /mnt/boot/initrd.img-4.19.0-10-4kc-malta .  # copy only initrd.img file
cp -r /mnt/boot .                                 # copy the entire boot folder

# Unmount the image:
sudo umount /mnt
sudo qemu-nbd -d /dev/nbd0


# Start the image type:
# NOTE! Check all!
qemu-system-mips -M malta \
  -m 256 -hda hda.img \
  -kernel vmlinux-4.19.0-10-4kc-malta \
  -initrd initrd.img-4.19.0-10-4kc-malta \
  -append "root=/dev/sda1 console=ttyS0 nokaslr" \
  -nographic \
  -device e1000-82545em,netdev=user.0 \
  -netdev user,id=user.0,hostfwd=tcp::5555-:22

# To access the guest machine from Host machine to upload a file:
scp -P 5555 file.txt root@localhost:/tmp

# Or to connect via ssh:
ssh root@localhost -p 5555



## MAIN

while :
do

    clear

    printf "\n\
    printf "${RED}************************************************${NC}\n"
    printf "${GREEN} UNSTABLE MISP QEMU EMULATOR INSTALL & RUN${NC}\n"
    printf "${RED}************************************************${NC}\n"
    printf "\n"
    printf "\t${GREEN}  \/                      \/${NC}\n"
    printf "\t${RED} ()()  USE SUDO || GTFO  ()()${NC}\n"
    printf "\t${RED}  ()   <3<3<3<3<3<3<3<3   ()${NC}\n\n\n"

    echo "1) Update & install QEMU" 
    echo "2) Download Installer & Kernel boot files" 
    echo "3) Create QEMU image file" 
    echo "4) Install Debian MIPS (Graphical install)" 
    echo "5) Mount image file boot partition"
    echo "6) Run Debian MIPS" 
    echo "7) JUST GO !!" 
    echo "8) Exit" 
    echo "9) " 
    echo "10) " 
    echo ""
    echo "Selection: "

    read -r SELECT
    case $SELECT in
	1) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	1) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	2) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	3) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	4) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	5) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	6) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	7) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	8) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	9) 
	    _install_package
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	 ;;
