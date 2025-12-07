default:
    just --list

setup:
    scripts/setup-k8s-vpc.sh

run VM_ID:
    VM_ID={{VM_ID}} scripts/run-vm-no-ssh.sh 

run-k8s:
    VM_ID=1 scripts/run-vm-ssh.sh
    VM_ID=2 scripts/run-vm-ssh.sh
    VM_ID=3 scripts/run-vm-ssh.sh

run-no-ssh VM_ID:
    VM_ID={{VM_ID}} scripts/run-vm-no-ssh.sh 

run-ssh VM_ID:
    VM_ID={{VM_ID}} scripts/run-vm-ssh.sh 

stop-all:
    #!/usr/bin/env bash
    kill $(pgrep qemu-system)
