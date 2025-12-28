#!/usr/bin/env bash
# qemu-img create -f qcow2 -F qcow2 -b arch.qcow2 arch-vm1.qcow2
set -euo pipefail

VM_ID="${VM_ID:-1}"
VM_IMG="${VM_IMG:-images/linux-$VM_ID.qcow2}"
VM_PORT=$(printf '%02u' "$VM_ID")
MAC_SUFFIX=$(printf '%02x' "$VM_ID")
VM_MAC="52:54:00:12:34:${MAC_SUFFIX}"
TAP_IF="tap-k8s${VM_ID}"

qemu-system-x86_64 \
    -machine q35,accel=kvm \
    -enable-kvm \
    -cpu host \
    -smp sockets=1,cores=4,threads=1 \
    -m size=4G,slots=2,maxmem=8G \
    -blockdev driver=file,filename=${VM_IMG},node-name=drive0_file \
    -blockdev driver=qcow2,file=drive0_file,node-name=drive0_qcow2 \
    -device virtio-blk-pci,drive=drive0_qcow2,bootindex=1 \
    -netdev tap,id=nic${VM_ID},ifname=${TAP_IF},script=no,downscript=no \
    -device virtio-net,netdev=nic${VM_ID},mac="${VM_MAC}" \
    -daemonize -display none
