default:
    just --list

setup ISO IMG="./images/linux.qcow2":
    ISO={{ISO}} VM_IMG={{IMG}} scripts/run-vm-bootstrap.sh

# Run VM with the new simplified script
# Usage: just run [options] <image.qcow2> [VM_ID]
# Options (must come before image):
#   -t  Terminal/nographic mode
#   -g  Graphical mode (default)
#   -c  Skip cloud-init ISO
# Arguments:
#   image.qcow2  Path to VM disk image (required)
#   VM_ID        VM ID number (default: 1)
# Examples:
#   just run images/node-1.qcow2
#   just run -t images/node-1.qcow2
#   just run -t images/node-1.qcow2 2
#   just run -c images/node-1.qcow2
#   just run -t -c images/node-1.qcow2 3
run *ARGS:
    scripts/run-vm.sh {{ARGS}}

setup-vpc:
    scripts/setup-vpc.sh

run-vpc:
    VM_ID=1 VM_IMG=images/debian-13-1.qcow2 scripts/run-vm-vps.sh
    VM_ID=2 VM_IMG=images/debian-13-2.qcow2 scripts/run-vm-vps.sh
    VM_ID=3 VM_IMG=images/debian-13-3.qcow2 scripts/run-vm-vps.sh

stop:
    ssh root@10.100.1.30 'poweroff'
    ssh root@10.100.1.20 'poweroff'
    ssh root@10.100.1.10 'poweroff'

stop-all:
    #!/usr/bin/env bash
    kill $(pgrep qemu-system)

plan-vms:
    cd ansible && ansible-playbook playbook.yml --check --diff

configure-vms:
    cd ansible && ansible-playbook playbook.yml

# Setup/provision VMs using Ansible
setup-vm:
    cd ansible && ansible-playbook playbooks/provision.yml

# Clean up all VM-related files created by Ansible
clean-vm:
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
