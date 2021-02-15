#!/bin/bash

IP_MASTER="172.10.10.100"
NETWORK_CID="192.168.0.0/16"

function initialize_kubernetes(){
echo ""
echo "--------------------------------------"
echo "[TASK 1] Initialize Kubernetes Cluster"
echo "--------------------------------------"
echo ""
kubeadm init --apiserver-advertise-address=${IP_MASTER} --pod-network-cidr=${NETWORK_CID} |tee -a >> /root/kubeinit.log 
}

function kube_admin_config(){
echo ""
echo "---------------------------------------------------------------"
echo "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
echo "---------------------------------------------------------------"
echo ""
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
cat /etc/kubernetes/admin.conf 
}

function deploy_plugin_network(){
echo ""
echo "------------------------------"
echo "[TASK 3] Deploy Calico network"
echo "------------------------------"
echo ""
su - vagrant -c "kubectl create -f https://docs.projectcalico.org/latest/manifests/calico.yaml"
}

function cluster_join(){
echo ""
echo "------------------------------------------------------------------"
echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
echo "------------------------------------------------------------------"
echo ""
kubeadm token create --print-join-command > /joincluster.sh
}

initialize_kubernetes;
kube_admin_config;
deploy_plugin_network;
cluster_join;