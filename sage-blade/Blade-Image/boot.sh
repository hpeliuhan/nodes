#!/bin/bash

apt-get -y update 
apt-get -y install ssh

sed -i '/efi/d' /etc/fstab
sed -i '/\/media\/sys-data/d' /etc/fstab

umount /boot/efi
umount /media/sys-data

mkdir ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEScCdR3mr+QgCnuvGSwsjw1lmatwrHvVvUtEoc7du5vCMTXT25L3rqhaG8Ngy4OTAfVEtSR0qfgJ6UrH1oyacPMBYAETOfnHqKqoi1Dcej9f3+QuBNA7pOIjLK2jqbK+VGPHEM9NVKXb8XbcL9mpn+sKy4f2J1kRMD79+5R+8EbV2jVcwwOa/1+bsbF/jtGlmoHD4RbNHrO65Y2BuLpQMYSv4Q0lwwe/pwYSYgCkeD0ve9XfwZktnluYyOQjaTw+qyMpNjfYCfWDHZtKHeUCRcNgpXydcJ6Obc/h9kQQC1ZWU1GDc+BFWwo/ZLrHeedilggUwRTqpM9j3lYPi1NfX /home/rajesh/.ssh/id_rsa_waggle_user" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsYPMSrC6k33vqzulXSx8141ThfNKXiyFxwNxnudLCa0NuE1SZTMad2ottHIgA9ZawcSWOVkAlwkvufh4gjA8LVZYAVGYHHfU/+MyxhK0InI8+FHOPKAnpno1wsTRxU92xYAYIwAz0tFmhhIgnraBfkJAVKrdezE/9P6EmtKCiJs9At8FjpQPUamuXOy9/yyFOxb8DuDfYepr1M0u1vn8nTGjXUrj7BZ45VJq33nNIVu8ScEdCN1b6PlCzLVylRWnt8+A99VHwtVwt2vHmCZhMJa3XE7GqoFocpp8TxbxsnzSuEGMs3QzwR9vHZT9ICq6O8C1YOG6JSxuXupUUrHgd /home/rajesh/.ssh/id_rsa_waggle_aot" >> ~/.ssh/authorized_keys

sed -i 's|overlayroot=""|overlayroot="device:dev=/dev/sda4,timeout=180,recurse=0"|' /etc/overlayroot.conf

#ensure waggle config directory exists
mkdir -p /etc/waggle

curl https://raw.githubusercontent.com/sagecontinuum/nodes/master/sage-blade/Blade-Image/files/waggle-registration > /usr/bin/waggle-registration
chmod 755 /usr/bin/waggle-registration

curl https://raw.githubusercontent.com/sagecontinuum/nodes/master/sage-blade/Blade-Image/files/waggle-reverse-tunnel > /usr/bin/waggle-reverse-tunnel
chmod 755 /usr/bin/waggle-reverse-tunnel

curl https://raw.githubusercontent.com/sagecontinuum/nodes/master/sage-blade/Blade-Image/files/waggle-registration.service > /etc/systemd/system/waggle-registration.service

curl https://raw.githubusercontent.com/sagecontinuum/nodes/master/sage-blade/Blade-Image/files/waggle-reverse-tunnel.service > /etc/systemd/system/waggle-reverse-tunnel.service

systemctl enable waggle-registration.service waggle-reverse-tunnel.service
echo "140.221.47.67 beehive" >> /etc/hosts

ln -s /media/plugin-data /var/lib/docker
rm /etc/rc.local

reboot
