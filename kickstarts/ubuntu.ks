# Generated by Kickstart Configurator
#platform=x86

# System language
lang en_US
# Language modules to install
langsupport en_US
# System keyboard
keyboard us
# System mouse
#mouse
# System timezone
timezone Etc/UTC
# Root password
rootpw --iscrypted $default_password_crypted
# Initial user
user --disabled
# Reboot after installation
reboot
# Use text mode install
text
# Install OS instead of upgrade
install
# Use Web installation
url --url http://192.168.255.1:3142/ubuntu
# System bootloader configuration
bootloader --location=mbr 
# Clear the Master Boot Record
zerombr yes
# Partition clearing information
clearpart --all --initlabel 
# Disk partitioning information
part swap --size 512 
part / --fstype ext3 --size 1 --grow 
# System authorization infomation
auth  --useshadow  --enablemd5 
$SNIPPET('ubuntu_network_config')
# Always install the server kernel.
preseed --owner d-i     base-installer/kernel/override-image    string linux-server
# Install the Ubuntu Server seed.
preseed --owner tasksel tasksel/force-tasks     string server

# Firewall configuration
firewall --disabled 
# Do not configure the X Window System
skipx

%pre
$kickstart_start
# Network information
$SNIPPET('pre_install_ubuntu_network_config')

%packages
openssh-server
ruby-libs
ruby-rdoc
$SNIPPET('puppet_install_if_enabled')

%post
$SNIPPET('log_ks_post')
$SNIPPET('host_inject')
$SNIPPET('puppet_register_if_enabled')
$SNIPPET('kickstart_done')
