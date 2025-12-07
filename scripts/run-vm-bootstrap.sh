#!/usr/bin/env bash
set -euo pipefail

qemu-img create -f qcow2 arch-niri.qcow2 25G
# qemu-img create -f qcow2 -F qcow2 -b arch.qcow2 arch-vm1.qcow2

IMG="${IMG:-arch-niri.qcow2}"

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -m 4096 \
  -smp cpus=4,sockets=1,cores=4,threads=1 \
  -drive file=${IMG},if=virtio,format=qcow2 \
  -cdrom archlinux-2025.12.01-x86_64.iso \
  -boot d \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 \
  -device virtio-net,netdev=n1
