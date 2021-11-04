#!/bin/bash

IP_MASTER="10.50.50.100"
NETWORK_CID="10.50.50.0/24"

function initialize_kubernetes(){
echo ""
echo "--------------------------------------"
echo "[TASK 1] Initialize Kubernetes Cluster"
echo "--------------------------------------"
echo ""
kubeadm config images pull
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
echo "---------------------------------"
echo "[TASK 3] Deploy Weave-net network"
echo "---------------------------------"
echo ""
#su - vagrant -c "kubectl create -f https://docs.projectcalico.org/latest/manifests/calico.yaml"
su - vagrant -c "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\""
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