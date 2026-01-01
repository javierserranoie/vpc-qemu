#!/usr/bin/env bash
set -euo pipefail
PROJECT_ROOT="$(pwd)"
CLOUDINIT_DIR="${PROJECT_ROOT}/cloudinit/vms"
VM_IMAGES_DIR="${PROJECT_ROOT}/images"
OVMF_VARS_DIR="${PROJECT_ROOT}/ovmf_vars"

echo "Cleaning up VM files..."

# Stop all running VMs
echo "Stopping running VMs..."
pkill -f qemu-system-x86_64 || true

# Remove cloud-init ISOs and directories
if [[ -d "$CLOUDINIT_DIR" ]]; then
    echo "Removing cloud-init files..."
    find "$CLOUDINIT_DIR" -name "*-cloud-init.iso" -type f -delete
    find "$CLOUDINIT_DIR" -type d -mindepth 1 -exec rm -rf {} + || true
fi

# Remove VM disk images (but keep base image)
if [[ -d "$VM_IMAGES_DIR" ]]; then
    echo "Removing VM disk images..."
    find "$VM_IMAGES_DIR" -name "*.qcow2" -type f ! -name "debian-13-generic-amd64.qcow2" -delete
fi

# Remove OVMF vars files
if [[ -d "$OVMF_VARS_DIR" ]]; then
    echo "Removing OVMF vars files..."
    rm -f "$OVMF_VARS_DIR"/OVMF_VARS_*.4m.fd
fi

echo "Cleanup complete!"
