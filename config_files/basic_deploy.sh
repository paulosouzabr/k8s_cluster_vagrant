#!/bin/bash

IP_MASTER="172.10.10.100"
IP_NODE_1="172.10.10.101"
IP_NODE_2="172.10.10.102"
ROOT_PASS="change_me"


function install_docker(){
  echo ""
  echo "-----------------------------------------"
  echo "[TASK 01] Install docker container engine"
  echo "-----------------------------------------"
  echo ""
  sudo apt update && sudo apt dist-upgrade -y
  sudo apt-get install apt-transport-https ca-certificates curl software-properties-common ssh -y
  curl -fsSL http://get.docker.com |sudo bash

  sudo usermod -aG docker vagrant
  sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
  {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "100m"
    },
    "storage-driver": "overlay2"
  }
EOF'
}

function enable_docker_service(){
  echo ""
  echo "-----------------------------------------"
  echo "[TASK 02] Enable and start docker service"
  echo "-----------------------------------------"
  echo ""

  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo systemctl daemon-reload
  sudo systemctl enable docker >/dev/null 2>&1
  sudo systemctl restart docker
  sudo systemctl status docker
}

function add_sysctl_settings(){
  echo ""
  echo "-----------------------------"
  echo "[TASK 03] Add sysctl settings"
  echo "-----------------------------"
  echo ""

  sudo bash -c 'cat >> /etc/sysctl.d/kubernetes.conf <<EOF
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
EOF'
  sudo sysctl --system >/dev/null 2>&1
}

function disable_swap(){
  echo ""
  echo "-----------------------------------"
  echo "[TASK 04] Disable and turn off SWAP"
  echo "-----------------------------------"
  echo ""

  sudo sed -i '/swap/d' /etc/fstab
  sudo swapoff -a
}

function install_deb_pkgs(){
  echo ""
  echo "--------------------------------------------"
  echo "[TASK 05] Installing apt-transport-https pkg"
  echo "--------------------------------------------"
  echo ""

  sudo apt-get update && sudo apt-get install -y apt-transport-https curl
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
}

function install_kubernetes(){ 
  sudo bash -c 'cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
  deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF'

  sudo ls -ltr /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update -yq

  echo ""
  echo "---------------------------------------------------------"
  echo "[TASK 06] Install Kubernetes kubeadm, kubelet and kubectl"
  echo "---------------------------------------------------------"
  echo ""
  sudo apt-get install -yq kubelet kubeadm kubectl

  echo ""
  echo "------------------------------------------"
  echo "[TASK 07] Enable and start kubelet service"
  echo "------------------------------------------"
  echo ""
  sudo systemctl enable kubelet 
  sudo systemctl start kubelet
  sudo systemctl status kubelet 
}


function ssh_change_config(){
  echo ""
  echo "--------------------------------------------"
  echo "[TASK 08] Enable ssh password authentication"
  echo "--------------------------------------------"
  echo ""
  sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  sudo systemctl status sshd
}

function update_hosts_file(){
  echo ""
  echo "--------------------------------"
  echo "[TASK 09] Update /etc/hosts file"
  echo "--------------------------------"
  echo ""

  sudo bash -c "cat >> /etc/hosts" << EOF   
### VAGRANT K8S HOSTS #### 
${IP_MASTER} master.lab.tech master
${IP_NODE_1} node-1.lab.tech node-1
${IP_NODE_2} node-2.lab.tech node-2 
EOF
  hostname --fqdn
  cat /etc/hostname
  cat /etc/hosts
  ping -c4 master.lab.tech
  ping -c4 node-1.lab.tech
  ping -c4 node-2.lab.tech
}


function set_root_passwd(){
echo ""
echo "---------------------------"
echo "[TASK 10] Set root password"
echo "---------------------------"
echo ""
echo -e "${ROOT_PASS}\n${ROOT_PASS}" | sudo passwd root
}

install_docker;
enable_docker_service;
add_sysctl_settings;
disable_swap;
install_deb_pkgs;
install_kubernetes;
ssh_change_config;
update_hosts_file;
set_root_passwd;

# Update vagrant user's bashrc file
sudo echo "export TERM=xterm" >> /etc/bashrc
