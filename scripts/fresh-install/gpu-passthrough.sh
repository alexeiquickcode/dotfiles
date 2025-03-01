
# 1. Enable IOMMU in grub
sudo nano /etc/default/grub

# Modify the GRUB_CMDLINE_LINUX_DEFAULT line:
# amd_iommu=on, vfio-pci.ids=10de:2489,10de:228b

# Update grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot

# ----------------------------------------

# 2. Blacklist the GPU
lspci -nn | grep NVIDIA 

# Create a blacklist file
sudo nano /etc/modprobe.d/vfio.conf

# Device IDs look something like this: [10de:1b06]
# Add
# Where XXXX = 10de:1b06
# and YYYY = audio driver
options vfio-pci ids=XXXX,YYYY
softdep nvidia pre: vfio-pci

# Black list kernel modules
#

# ----------------------------------------
# 3. Assign GPU to VFIO

sudo nano /etc/mkinitcpio.conf

# Add modules
# MODULES=(vfio vfio_pci vfio_iommu_type1)

# Rebuild initramfs
sudo mkinitcpio -P linux

sudo reboot

# To check if devices are bound to l

# For VM default network error
# sudo virsh net-autostart default
# sudo virsh net-start default
#
# Get devices ids in the same group

# From 
# https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Ensuring_that_the_groups_are_valid
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;

