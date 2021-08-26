#! /bin/bash


# Mount and Run Debian Jessie (ARM) in QEMU:
# tämä on testi kirjoitusta tällä näppiksellä


# Make sure that Jessie .img is mounted in /mnt/raspbian
#	- sudo mount -v -o offset=<calculate offset: start*512> -t ext4 ~/qemu_vms/<rasbian_image.img>
#	- Comment out all:  sudo vi /mnt/raspbian/etc/ld.so.preload
#	- coinfigure fstab, if needed



#----------------------------------------
# !!! RUN IN VIRTUAL MACHINE (UBUNTU) !!!
#----------------------------------------



# Set script colors:
NC='\033[0m'		# No color
GREEN='\033[1;32m'
#BLUE='\033[1;34m'
#GRAY='\033[0;36m'
RED='\033[0;31m'


#**************
# ARM EMULATOR
#**************

# Set variables
image_iso="$HOME/qemu_vms/2017-04-10-raspbian-jessie.img"
image_start="$(fdisk -l "$image_iso" | tail -n 1 | awk '{print $2}')"
image_offset=$((image_start*512))
qemu_kernel="$HOME/qemu_vms/qemu-rpi-kernel/kernel-qemu-4.4.34-jessie"
ERROR_LOG="$HOME/qemu-vms/error_log.txt"

# Create installation error log:
touch "$HOME/qemu_vms/error_log.txt"



# FUNCTIONS (Selections):
#------------------------

_install-qemu() {
	apt-get update -y
	apt-get install qemu-system -y
}

# Download & set environment:
_dwnld-set() {
	mkdir "$HOME/qemu_vms"
	cd "$HOME/qemu_vms" || return
	git clone https://github.com/dhruvvyas90/qemu-rpi-kernel.git
	cd - ||return
	echo ""
	echo ""
	echo "Download Debian Jessie image from: \
			http://downloads.raspberrypi.org/raspbian/images/raspbian-2017-04-10/"
	echo "And Unzip to ~/qemu_vms"
	echo "OR.. use selection 3 and go get some coffee!" 
	sleep 5
}

# Download Raspbian Jessie Image:
_dwnld-img() {
	cd "$HOME/qemu_vms" ||return
	wget http://downloads.raspberrypi.org/raspbian/images/raspbian-2017-04-10/2017-04-10-raspbian-jessie.zip
	unzip 2017-04-10-raspbian-jessie.zip
	rm 2017-04-10-raspbian-jessie.zip
	cd - ||return
}

# Mount and configure Raspbian:
_mount-rpi() {
	mkdir /mnt/raspbian
	cd "$HOME/qemu_vms" ||return
	mount -v -o offset="$image_offset" -t ext4 "$image_iso /mnt/raspbian"
	echo ""
	echo "Starting vi: comment out all fields (#)"
	sleep 7
	vi /mnt/raspbian/etc/ld.so.preload
	cd - ||return
	
	# Change "qemu_vms" permissions from Root to $USER
	chown -R "$USER:$USER $HOME/qemu_vms"
} #>> $ERROR_LOG

_fstab-edit() {
	echo "Requires manual editing"
	echo "IF you see anything mmcblk0 in fstab, then:"
	echo "1. Replace the first entry containing /dev/mmcblk0p1 with /dev/sda1"
	echo "2. Replace the second entry containing /dev/mmcblk0p2 with /dev/sda2"
	echo "3. Save & Exit"
	echo "INFO IN README.md"
	sleep 7

	vi /mnt/raspbian/etc/fstab
	cd "$HOME" ||return
	umount /mnt/raspbian
}

# Start Debian Jessie in QEMU:
_start-rpi-ssh() {
	qemu-system-arm -kernel "$qemu_kernel" -cpu arm1176 -m 256 -M versatilepb -serial stdio \
		-usb -device usb-mouse -show-cursor -append "root=/dev/sda2 rootfstype=ext4 rw" \
		-hda "$image_iso" -redir tcp:5022::22 -no-reboot
}

_start-rpi() {
	#qemu-system-arm -kernel "$qemu_kernel" -cpu arm1176 -m 256 -M versatilepb -serial stdio \
	#	-usb -device usb-mouse -show-cursor -append "root=/dev/sda2 rootfstype=ext4 rw" \
	#	-hda "$image_iso" -no-reboot

	qemu-system-arm -kernel "$qemu_kernel" -cpu arm1176 -m 256 -M versatilepb -serial stdio \
		-append "root=/dev/sda2 rootfstype=ext4 rw" -hda "$image_iso" -redir tcp:5022::22 -no-reboot
}

# Resize Raspbian Image: !!! NOT WORKING !!!
_resize-img() {
	cd "$HOME/qemu_vms" ||return
	cp "$image_iso raspbian.img"
	# Resize +6G
	qemu-image resize raspbian.img +6G

	# Start the original Raspbian with enlarged image as second hard drive:
	#qemu-system-arm -kernel "$qemu_kernel" -cpu arm1176 -m 256 \
	#		-M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" \
	#		-hda "$HOME/qemu_vms/$image_iso" -redir tcp:5022::22 \
	#      	-no-reboot -hdb raspbian.img
	qemu-system-arm -kernel "$qemu_kernel" -cpu arm1176 -m 256 \
			-M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" \
			-hda "$HOME/qemu_vms/$image_iso" -redir tcp:5022::22 \
			-no-reboot -hdb raspbian.img
}


#***************
# MISP EMULATOR
#***************

## ADD MISP EMULATOR CODE HERE (?)


# MAIN:
#-------

while :
do
	
	clear

	printf "\n\n"
	printf "${RED}************************************************${NC}\n"
	printf "${GREEN} UNSTABLE RASPBIAN JESSIE INSTALL & RUN IN QEMU${NC}\n"
	printf "${RED}************************************************${NC}\n"
	printf "\n"
	printf "\t${GREEN}  \/                      \/${NC}\n"
	printf "\t${RED} ()()  USE SUDO || GTFO  ()()${NC}\n"
	printf "\t${RED}  ()   <3<3<3<3<3<3<3<3   ()${NC}\n\n\n"

	echo "1) Update & Install QEMU" 
	echo "2) Download Raspbian Jessie Kernel & Set Environment"
	echo "3) Download Raspbian Jessie ISO Image"
	echo "   (it takes some time, depending on your connection)"
	echo "4) Mount Raspbian"
	echo "5) Edit Raspbian fstab"
	echo "6) Run Raspbian with SSH (redir 5022::22)"
	echo "7) Run Raspbian without SSH"
	echo "8) Resize Raspbian Image (Recommended)"
	echo "9) EXIT"
	echo ""
	echo "Selection: "


	read -r SELECT
	case $SELECT in
		1)
			_install-qemu
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
			
		2)
			_dwnld-set
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
		3)
			_dwnld-img
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;

		4)
			_mount-rpi
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
		5)
			_fstab-edit
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;

		6)
			_start-rpi-ssh
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
		7)
			_start-rpi
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
		8)
			_resize-img
			printf "${GREEN}All Good, continue${NC}\n"
			sleep 3
			echo ""
			echo "Selection: "
			;;
		9)
			break
			;;
		*)
			echo "How many options in menu? Try again, please."
			;;
	esac
done

printf "\n\nHope it works.. If not, please fix & improve <3\n\n"
exit 0

