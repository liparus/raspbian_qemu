#! /bin/bash

#
#
# Add MIPS architecture to Raspbian Qemu ARM emulator script (raspi-qemu-setup.sh)
#
# Commands & guide from: https://markuta.com/how-to-build-a-mips-qemu-image-on-debian/


# set script colors
NC='\033[0m'		# No color
GREEN='\033[1;32m'
#BLUE='\033[1;34m'
GRAY='\033[0;36m'
RED='\033[0;31m'


#***************
# MIPS EMULATOR
#***************



## FUNCTIONS (Selections):
#-------------------------


_install_qemu() {
	sudo apt-get install qemu-system-mips -y
}


_download_installer() {
	# Download installer (Malta)
	# NOTE: There are two versions Malta and Octeon.
	wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/initrd.gz

	# Download Kernel
	# NOTE: versions might differ
	wget http://ftp.debian.org/debian/dists/stable/main/installer-mips/current/images/malta/netboot/vmlinux-4.19.0-16-4kc-malta
    
    exit 0
    }


## ! NOTE: ADD VERIFY DOWNLOAD !
# shasum -a 256 initrd.gz vmlinux-4.19.0-10-4kc-malta
# ---------------------------------------------------

_create_image() {
	# Create an qcow2 format image with 2G of storage:
	qemu-img create -f qcow2 hda.img 2G
	
	exit 0
    }



## ! NOTE: next step is graphical installation !
# ---------------------------------------------

_install_debian_misp() {
	# Install Debian MIPS:
	qemu-system-mips -M malta \
  	-m 256 -hda hda.img \
  	-kernel vmlinux-4.19.0-15-4kc-malta \
  	-initrd initrd.gz \
  	-append "console=ttyS0 nokaslr" \
  	-nographic
   
	exit 0
    }




_mount_bootpart() {
	# Mount the boot partition of the image file: 
	sudo modprobe nbd max_part=63
	sudo qemu-nbd -c /dev/nbd0 hda.img
	sudo mount /dev/nbd0p1 /mnt


	## Copy a single file or the entire folder to the current directory:
	cp -r /mnt/boot/initrd.img-4.19.0-11-4kc-malta .  # copy only initrd.img file
	#cp -r /mnt/boot .                                # copy the entire boot folder

	sleep 1

	## Unmount the image:
	sudo umount /mnt
	sudo qemu-nbd -d /dev/nbd0

	exit 0
    }



_start_qemu() {
    # Start the image type:
    # NOTE! Check all!
    qemu-system-mips -M malta \
	-m 256 -hda hda.img \
	-kernel vmlinux-4.19.0-11-4kc-malta \
	-initrd initrd.img-4.19.0-11-4kc-malta \
	-append "root=/dev/sda1 console=ttyS0 nokaslr" \
	-nographic \
	-device e1000-82545em,netdev=user.0 \
	-netdev user,id=user.0,hostfwd=tcp::5555-:22

	exit 0
    }



_setup_ssh() {

    ## To access the guest machine from Host machine to upload a file:
    #scp -P 5555 file.txt root@localhost:/tmp

    # Or to connect via ssh:
    ssh root@localhost -p 5555

    }


_uninstall_deb() {
    
    sudo rm hda.img
    sudo rm initrd.gz
    sudo rm vmlinux-4.19.0-11-4kc-malta
    sudo rm initrd.img-4.19.0-11-4kc-malta

    exit 0
    } > /dev/null 2>&1

## MAIN

while :
do

    clear

    printf "\n"
    printf "\t${RED}*****************************${NC}\n"
    printf "\t${GREEN} UNSTABLE QEMU MIPS EMULATOR${NC}\n"
    printf "\t${RED}*****************************${NC}\n"
    printf "\n"
    printf "\t${GREEN}  \/                      \/${NC}\n"
    printf "\t${RED} ()()  USE SUDO || GTFO  ()()${NC}\n"
    printf "\t${RED}  ()   <3<3<3<3<3<3<3<3   ()${NC}\n\n\n"

    echo "1) Update & install QEMU" 
    echo "2) Download Installer & Kernel boot files" 
    echo "3) Create QEMU image file" 
    printf "4) Install Debian MIPS (${GRAY}Graphical install, takes forever to complete${NC})\n" 
    echo "5) Mount image file boot partition"
    echo "6) Run Debian MIPS" 
    printf "7) JUST GO !! (${RED}DOES NOTHING!${NC})\n"
    printf "8) SSH Connect (${RED}DOES NOTHING!${NC})\n"
    printf "9) Uninstall Debian MIPS\n" 
    echo "0) Exit" 
    echo ""
    echo "Selection: "

    read -r SELECT
    case $SELECT in
	1) 
	    _install_qemu
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	2) 
	    _download_installer
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	3) 
	    _create_image
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	4) 
	    _install_debian_misp
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	5) 
	    _mount_bootpart
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	6) 
	    _start_qemu
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	7) 
	    _just_doit
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	8)
	    _setup_ssh
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	9)
	    _uninstall_deb
	    printf "${GREEN}All good, continue${NC}\n"
	    sleep 3
	    echo ""
	    echo "Selection: "
	    ;;

	0)
	    break
	    ;;

	*) 
	    echo "How many options on menu? Try again, please."
	 ;;
    esac
done

printf "\n\nHope it works.. If not, please fix & improve <3\n\n"
exit 0

	 
