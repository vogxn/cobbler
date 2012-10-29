<?xml version="1.0"?>
   <installation mode="fresh" srtype="lvm">
      <primary-disk gueststorage="yes">sda</primary-disk>
      <keymap>us</keymap>
      <root-password>password</root-password>
      <source type="url">http://nfs2.lab.vmops.com/xensource/xen602source</source>
      <admin-interface name="eth0" proto="dhcp" />
      <timezone>Asia/calcutta</timezone>
      <time-config-method>ntp</time-config-method>
      <ntp-servers>ntp</ntp-servers>
      <ntpservers>0.in.pool.ntp.org</ntpservers>
   </installation>
