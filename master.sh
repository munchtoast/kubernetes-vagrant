#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --pod-network-cidr=10.244.0.0/16

# Copy Kube admin config and restart kubelet service
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "[TASK 3] Deploy flannel network"
su - vagrant -c "kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml"

# Generate Cluster join command
echo "[TASK 4] Generate and save cluster join command to /vagrant/joincluster.sh"
kubeadm token create --print-join-command > /vagrant/joincluster.sh 2>/dev/null

echo "[TASK 5] Copy kube config to project repository to access"
cp /home/vagrant/.kube/config /vagrant/.kubeconfig
