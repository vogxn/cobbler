# This file contains the kickstart used to create EC2 CentOS 6.3 AMI.

################################# Install mode #################################

# Install Linux instead of upgrade
install

# Graphical install mode
text

################################# Network setup ################################

# User DHCP
network --bootproto=dhcp --device=eth0

################################# Repositories #################################
# Base URL of CentOS 6.3 repository, should be adapted regarding geographical
# location.
url --url=http://ftp.heanet.ie/pub/centos/6.3/os/x86_64/

# Epel repositories containing some dependencies and cloud-init
repo --name=epel --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64
repo --name=epel-testing --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=testing-epel6&arch=x86_64

########################## System configuration ################################
# Do not configure the X Window System
skipx

# Set system language
lang en_US

# Set keyboard layout
keyboard us

# Set time zone
timezone --utc Etc/UTC

# Assign an unknown password to root (replace this with random stuff)
rootpw --iscrypted $1$h1xfuVt1$426ElReeaUreeZxAlIvCU.

# Request poweroff after installation
poweroff

# Do not run the Setup Agent on first boot
firstboot --disabled

# Enable firewall and open SSH and HTTP ports
firewall --enabled

############################# Disk partitioning ################################

# System bootloader configuration
bootloader --location=mbr --append "text"

# Disk partitioning information
# Actual creation of partition table can be found in %pre section.
part /     --onpart=/dev/xvde1
part swap --onpart=/dev/xvde2

############################### Packages #######################################

%packages

# Base packages
@Base

# Additional repositories
epel-release

# Cloudification
cloud-init

%pre
######################### Pre-install script ##################################

REAL_DISK=/dev/xvde

# Clear the MBR and reset partition table
dd if=/dev/zero of=$REAL_DISK bs=512 count=1
parted -s $REAL_DISK mklabel msdos

TOTAL=`parted -s $REAL_DISK unit mb print free | grep $REAL_DISK | awk '{print $3}' | cut -d "M" -f1`

# Calculate swap partition start point
let SWAP_START=$TOTAL-512

# Create partitions
parted -s $REAL_DISK mkpart primary ext3 0 $SWAP_START
parted -s $REAL_DISK mkpart primary $SWAP_START $TOTAL

%post
######################### Post-install script ##################################

cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
IPV6INIT="yes"
MTU="1500"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"
EOF

# Disable root password based login
cat >> /etc/ssh/sshd_config << EOF
PermitRootLogin no
PasswordAuthentication no
UseDNS no
EOF

# Create ec2-user
/usr/sbin/useradd ec2-user
/bin/echo -e 'ec2-user\tALL=(ALL)\tNOPASSWD: ALL' >> /etc/sudoers

# Get rid of problem with HWADDR
rm -f /etc/udev/rules.d/70-persistent-net.rules

# Set SSH banner
cat >> /etc/ssh/sshd_banner << EOF

-------------------------------------------------------------------------------
# This image has been automatically created with ComodIT - http://comodit.com #
#                                                                             #
# If you want to create your own fully customized EC2 image, register at      #
# http://comodit.com.                                                         #
------------------------------------------------------------------------------- 

EOF

sed -i "s|#Banner none|Banner /etc/ssh/sshd_banner|" /etc/ssh/sshd_config

