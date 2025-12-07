#!/usr/bin/env bash
set -euo pipefail

IMG="${IMG:-images/arch-vm1.qcow2}"
TAP="${TAP:-tap-k8s1}"

qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -m 4096 \
    -drive file="${IMG}",if=virtio,format=qcow2 \
    -netdev tap,id=n1,ifname="${TAP}",script=no,downscript=no \
    -device virtio-net-pci,netdev=n1 \
    -daemonize \
    -display none
