#!/usr/bin/env bash
# qemu-img create -f qcow2 arch.qcow2 25G
# qemu-img create -f qcow2 -F qcow2 -b arch.qcow2 arch-vm1.qcow2
#  -cdrom archlinux-2025.12.01-x86_64.iso \
#  -boot d \
set -euo pipefail

VM_ID="${VM_ID:-1}"

MAC_SUFFIX=$(printf '%02x' "$VM_ID")
VM_MAC="52:54:00:12:34:${MAC_SUFFIX}"

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4096 \
    -smp cpus=2,sockets=1,cores=2,threads=1 \
    -drive file=images/arch-vm${VM_ID}.qcow2,if=virtio,format=qcow2 \
    -netdev tap,id=n${VM_ID},ifname="tap-k8s${VM_ID}",script=no,downscript=no \
    -device virtio-net,netdev=n${VM_ID},mac="${VM_MAC}" \
    -daemonize -display none
