#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
INV=${1:-$HOME/yc-k8s-project/kubespray/inventory/mycluster/inventory.ini}
GVDIR="$(dirname "$INV")/group_vars"
MPUB=$(terraform -chdir=infra output -raw master_public_ip)
MIP=$(terraform -chdir=infra output -raw master_internal_ip)
mapfile -t WPUB < <(terraform -chdir=infra output -json worker_public_ips   | jq -r '.[]')
mapfile -t WIP  < <(terraform -chdir=infra output -json worker_internal_ips | jq -r '.[]')

cat > "$INV" <<EOT
[all]
k8s-master-1 ansible_host=${MPUB} ip=${MIP} etcd_member_name=etcd1
k8s-worker-1 ansible_host=${WPUB[0]} ip=${WIP[0]}
k8s-worker-2 ansible_host=${WPUB[1]} ip=${WIP[1]}

[kube_control_plane]
k8s-master-1

[etcd]
k8s-master-1

[kube_node]
k8s-worker-1
k8s-worker-2

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/k8s_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT

cat > "$GVDIR/k8s_cluster/yc-overrides.yml" <<EOT
---
supplementary_addresses_in_ssl_keys: ["${MPUB}"]
calico_ipip_mode: "Never"
calico_vxlan_mode: "Always"
kubeconfig_localhost: true
kubectl_localhost: true
EOT

cat > "$GVDIR/all/yc-overrides.yml" <<'YML'
---
containerd_registries_mirrors:
- prefix: "docker.io"
  mirrors:
  - host: "https://mirror.gcr.io"
    capabilities: ["pull", "resolve"]
YML

echo "OK: inventory -> $INV"
