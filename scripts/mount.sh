#!/usr/bin/env bash

if [ "$(uname -s)" != "Linux" ]; then
  echo "this script only runs on linux" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "run this as your user, not root" >&2
  exit 1
fi

set -euo pipefail

die() {
  echo "$1" >&2
  exit 1
}

restore_fstab() {
  sudo cp /etc/fstab.bak /etc/fstab
  sudo systemctl daemon-reload
}

lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS
echo

read -rp "partition to mount (e.g. sdb1, nvme1n1p1): " name
device="/dev/$name"
[ -b "$device" ] || die "$device is not a block device"

fstype="$(lsblk -no FSTYPE "$device")"
uuid="$(lsblk -no UUID "$device")"
label="$(lsblk -no LABEL "$device")"

[ -n "$fstype" ] && [ -n "$uuid" ] || die "$device has no filesystem"
[ -z "$(lsblk -no MOUNTPOINTS "$device")" ] || die "$device is already mounted"
! grep -q "UUID=$uuid" /etc/fstab || die "$device is already in /etc/fstab"

default="/mnt/${label:-$name}"
default="${default// /-}"
read -rp "mount point [$default]: " target
target="${target:-$default}"
[[ "$target" != *" "* ]] || die "mount point can't contain spaces"

# nofail and a short timeout so boot doesn't hang if the disk is unplugged
options="nofail,x-systemd.device-timeout=5s"
pass=0
case "$fstype" in
  ntfs)
    fstype=ntfs3
    options="$options,uid=$(id -u),gid=$(id -g),umask=022"
    ;;
  vfat | exfat)
    options="$options,uid=$(id -u),gid=$(id -g),umask=022"
    ;;
  ext2 | ext3 | ext4)
    options="defaults,$options"
    pass=2
    ;;
  *)
    options="defaults,$options"
    ;;
esac

entry="UUID=$uuid $target $fstype $options 0 $pass"
echo
echo "adding to /etc/fstab:"
echo "  $entry"
read -rp "continue? [y/N] " answer
[ "$answer" = "y" ] || die "cancelled"

sudo cp /etc/fstab /etc/fstab.bak
echo "$entry" | sudo tee -a /etc/fstab >/dev/null
sudo systemctl daemon-reload
sudo mkdir -p "$target"

if ! sudo mount "$target"; then
  restore_fstab
  die "mount failed, /etc/fstab restored"
fi

if [ "$(stat -c %U "$target")" = "root" ]; then
  read -rp "make $target owned by $USER? [y/N] " answer
  if [ "$answer" = "y" ]; then
    sudo chown "$USER:$(id -gn)" "$target"
  fi
fi

echo "mounted $device at $target, it will mount on every boot"
