#!/bin/bash

ROOT_PASS="change_me"
IP_MASTER="10.50.50.100"

function join_workers(){
echo ""
echo "-----------------------------------------------"
echo "[TASK 1 - NODE] Join node to Kubernetes Cluster"
echo "-----------------------------------------------"
echo ""
apt-get install -y sshpass >/dev/null 2>&1
curl -k https://$IP_MASTER:6443
sleep 10
sshpass -p "$ROOT_PASS" scp -o StrictHostKeyChecking=no master.lab.tech:/joincluster.sh /joincluster.sh
bash /joincluster.sh >/dev/null 2>&1
}

function update_ip_node(){
    echo ""
    echo "--------------------------------------"
    echo "[TASK 2 - NODE]  Update Kubelet Config"
    echo "--------------------------------------"
    echo ""

    IP_NODE_1="10.50.50.101"
    IP_NODE_2="10.50.50.102"    
    IP_VALIDATION="10.50.50.101/24"
    CHECK_IP=$(ip a |grep -i "10.50.50." |awk '{print $2}')
    KUBELET_1="Environment=\"KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml\""
    KUBELET_2="Environment=\"KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml --node-ip=$IP_NODE_1\""
    KUBELET_3="Environment=\"KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml --node-ip=$IP_NODE_2\""
    KUBEADM_CONFIG="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

    if [ $CHECK_IP = $IP_VALIDATION ];
    then
    sudo sed -i "s|${KUBELET_1}|$KUBELET_2|g" $KUBEADM_CONFIG
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    sudo cat $KUBEADM_CONFIG
    sleep 10
    else
    sudo sed -i "s|${KUBELET_1}|$KUBELET_3|g" $KUBEADM_CONFIG
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    sudo cat $KUBEADM_CONFIG
    sleep 10
    fi
}

join_workers;
update_ip_node;