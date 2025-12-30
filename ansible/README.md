# Ansible Project for VPC QEMU Configuration

This Ansible project applies network configurations and scripts to different VM images based on their roles.

## Project Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── inventory/
│   └── hosts.yml           # Inventory file with host groups
├── playbooks/
│   └── main.yml            # Main playbook
└── roles/
    ├── common/             # Common configurations for all hosts
    │   ├── files/
    │   │   ├── 10-br-k8s.network
    │   │   ├── disable-swap.sh
    │   │   ├── fix_iptables.sh
    │   │   └── network.config
    │   ├── handlers/
    │   │   └── main.yml
    │   └── tasks/
    │       └── main.yml
    ├── controlplane/       # Control plane specific configurations
    │   ├── files/
    │   │   └── network-controlplane.config
    │   └── tasks/
    │       └── main.yml
    ├── kubernetes/         # Kubernetes specific configurations
    │   ├── files/
    │   │   └── network-kubernetes.config
    │   └── tasks/
    │       └── main.yml
    └── worker/             # Worker node specific configurations
        ├── files/
        │   └── network-worker.config
        └── tasks/
            └── main.yml
```

## Roles

### Common Role
Applies to all hosts:
- Systemd network configuration (`10-br-k8s.network`)
- Disable swap script
- Fix iptables script
- Base network iptables rules and sysctl configuration

### Controlplane Role
Applies to control plane nodes:
- Kubernetes API server port (6443)
- etcd ports (2379-2380)
- kubelet port (10250)
- Controller-manager and scheduler ports (10257, 10259)

### Kubernetes Role
Applies to kubernetes nodes:
- Kubernetes sysctl configuration (bridge-nf-call-iptables, ip_forward)

### Worker Role
Applies to worker nodes:
- kubelet port (10250)
- kube-proxy port (10256)
- NodePort Services ports (30000-32767)

## Usage

### Running the playbook

```bash
cd ansible
ansible-playbook playbooks/main.yml
```

### Running against specific groups

```bash
# Apply only to controlplane nodes
ansible-playbook playbooks/main.yml --limit controlplane

# Apply only to worker nodes
ansible-playbook playbooks/main.yml --limit worker

# Apply only to kubernetes nodes
ansible-playbook playbooks/main.yml --limit kubernetes
```

### Running against specific hosts

```bash
# Apply to a specific host
ansible-playbook playbooks/main.yml --limit controlplane-1
```

### Customizing the inventory

Edit `inventory/hosts.yml` to match your actual host IPs and VM IDs. The `vm_id` variable is used in the network configuration template.

## Requirements

- Ansible 2.9 or higher
- Python 3 on target hosts
- SSH access to target hosts with sudo privileges
- iptables and systemd-networkd on target hosts

## Notes

- The playbook requires root privileges (become: yes)
- Network configuration uses VM_ID variable for IP assignment (10.100.1.${VM_ID}0/24)
- Scripts are copied to `/usr/local/bin` and executed
- iptables rules are saved and enabled as a service
