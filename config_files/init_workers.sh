#!/bin/bash

ROOT_PASS="pato@2099"

function join_workers(){
echo ""
echo "----------------------------------------"
echo "[TASK 1 - NODE] Join node to Kubernetes Cluster"
echo "----------------------------------------"
echo ""
apt-get install -y sshpass >/dev/null 2>&1
sshpass -p "$ROOT_PASS" scp -o StrictHostKeyChecking=no master.lab.tech:/joincluster.sh /joincluster.sh
bash /joincluster.sh >/dev/null 2>&1
}

join_workers;