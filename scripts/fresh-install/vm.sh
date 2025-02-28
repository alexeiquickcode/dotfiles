!/

sudo pacman -S virt-manager virt-viewer qemu bridge-utils libguestfs libvirt

sudo nano /etc/libvirt/libvirtd.conf
# uncomment uni_sock_group
# Setup RWX permisions 0770

sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd



# Add user groups
sudo usermod -aG libvirt $USER
newgrp libvirt

# Check virt
LC_ALL=C lscpu | grep Virtualization
