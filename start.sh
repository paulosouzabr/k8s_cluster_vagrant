#!/bin/bash

set -e

#####################################
## PRE REQ VALIDATION
#####################################
function lab_test(){
    echo ""
    echo "-----------------------------"
    echo "Reseting all configs for test"
    echo "-----------------------------"
    echo ""
    vagrant destroy -f
    restore_config_file;
    sudo apt remove virtualbox -y
    sudo apt remove vagrant -y
    rm -rf .vagrant
    vagrant init
    cp ./docs/bkp_files/vagrant_backup_tmp ./Vagrantfile
    clear
}

function restore_config_file(){
    cp ./docs/bkp_files/vagrant_backup_tmp ./config_files/Vagrantfile 
    cp ./docs/bkp_files/*.sh ./config_files/ 
} 

function check_so_version(){
    CHECK_UBUNTU=$(sudo grep -i -r "ID_LIKE" /etc/* |grep -i ID_LIKE|cut -d "=" -f2|sed 's/"//g' | awk 'NR==1{print $1}')
    if [ -f "/etc/debian_version" ];
    then 
        echo ""
        echo "------------------------------------"
        echo "Nice You use the debian distro based" 
        echo "------------------------------------"
        echo ""
    else
        echo ""
        echo "-------------------------------------------------------------"
        echo "$CHECK_UBUNTU"
        echo "Sorry, this project was development for debian distro based! " 
        echo "-------------------------------------------------------------"
        echo ""
        exit 
    fi 
}


function check_virtualbox_install(){
    VIRTUALBOX_PATH="/usr/bin/virtualbox"
    VB_CHECK_PATH=$(whereis virtualbox |awk '{print $2}')

    if [ "$VIRTUALBOX_PATH" == "$VB_CHECK_PATH" ];
    then
        echo ""
        echo "--------------------------------------------------"
        echo "Nice, you have the VirtualBox instaled, go to next" 
        echo "--------------------------------------------------"
        echo "" 
    else
        echo "-------------------------------------------------------------"
        echo "Ops, virtualbox is necessary! Do you want proceed to install?" 
        echo "-------------------------------------------------------------" 
        echo ""
        echo "-------------------------------"
        echo "1 - Ok, go ahead."
        echo "2 - No, Better in another time."
        echo "-------------------------------"
        echo ""
        read -r INPUT_STRING;
            case $INPUT_STRING in
            1) 
            echo ""
            echo "-------------------"
            echo "Starting install =)"
            echo "-------------------"
            echo ""
            sudo apt install virtualbox -y
            clear
            ;;
            2) 
            echo ""
            echo "------------------------"
            echo "That's Ok, see you later"
            echo "------------------------"
            echo ""
            exit
            ;;
            *)
            echo ""
            echo "----------------------------------"
            echo "Ops! Something is wrong, try again"
            echo "----------------------------------"
            echo ""
            exit
            ;;
            esac
    fi
}

function check_vagrant_install(){
    VAGRANT_PATH="/usr/bin/vagrant"
    VAGRANT_CHECK_PATH=$(whereis vagrant |awk '{print $2}')

    if [ "$VAGRANT_PATH" == "$VAGRANT_CHECK_PATH"  ];
    then
        echo ""
        echo "-----------------------------------------------"
        echo "Nice, you have the Vagrant instaled, go to next" 
        echo "-----------------------------------------------"
        echo ""  
    else
        echo "----------------------------------------------------------"
        echo "Ops, Vagrant is necessary, do you want proceed to install?" 
        echo "----------------------------------------------------------" 
        echo ""
        echo "-------------------------------"
        echo "1 - Ok, go ahead."
        echo "2 - No, Better in another time."
        echo "-------------------------------"
        echo ""
        read -r INPUT_STRING;
            case $INPUT_STRING in
            1) 
            echo ""
            echo "-----------------"
            echo "Start install =)"
            echo "-----------------"
            echo ""
            curl -O https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb && sudo dpkg -i ./vagrant_2.2.14_x86_64.deb
            rm ./vagrant_2.2.14_x86_64.deb
            vagrant --version
            sleep 3
            clear
            ;;
            2) 
            echo ""
            echo "------------------------"
            echo "That's Ok, see you later"
            echo "------------------------"
            echo ""
            exit
            ;;
            *)
            echo ""
            echo "----------------------------------"
            echo "Ops! Something is wrong, try again"
            echo "----------------------------------"
            echo ""
            exit
            ;;
            esac
    fi

}

function validate_pre-req(){
    check_so_version;
    check_virtualbox_install;
    check_vagrant_install;
} 

#####################################

function welcome(){
    BLANK_SPACE="                           " 
                                        
    echo ""                                        
    echo  "  /::      /::           /::                                             /::::::::        "
    echo  " | ::  /: | ::          | ::                                            |__  ::__/        "
    echo  " | :: /:::| ::  /:::::: | ::  /:::::::  /::::::  /::::::/::::   /::::::    | ::  /::::::  "
    echo  " | ::/:: :: :: /::__  ::| :: /::_____/ /::__  ::| ::_  ::_  :: /::__  ::   | :: /::__  :: "
    echo  " | ::::_  ::::| ::::::::| ::| ::      | ::  \ ::| :: \ :: \ ::| ::::::::   | ::| ::  \ :: "
    echo  " | :::/ \  :::| ::_____/| ::| ::      | ::  | ::| :: | :: | ::| ::_____/   | ::| ::  | :: "
    echo  " | ::/   \  ::|  :::::::| ::|  :::::::|  ::::::/| :: | :: | ::|  :::::::   | ::|  ::::::/ "
    echo  " |__/     \__/ \_______/|__/ \_______/ \______/ |__/ |__/ |__/ \_______/   |__/ \______/  "
    echo ""
    sleep 2                                                                       
    echo "${BLANK_SPACE}   /::   /::  /::::::   /::::::  "          
    echo "${BLANK_SPACE}  | ::  /::/ /::__  :: /::__  :: "          
    echo "${BLANK_SPACE}  | :: /::/ | ::  \ ::| ::  \__/ "          
    echo "${BLANK_SPACE}  | :::::/  |  ::::::/|  ::::::  "           
    echo "${BLANK_SPACE}  | ::  ::   :::__  :: \____  :: "          
    echo "${BLANK_SPACE}  | ::\  :: | ::  \ :: /::  \ :: "          
    echo "${BLANK_SPACE}  | :: \  ::|  ::::::/|  ::::::/ "          
    echo "${BLANK_SPACE}  |__/  \__/ \______/  \______/  "           
    echo ""                                        
    echo "${BLANK_SPACE}   /::        /::::::  /:::::::  "           
    echo "${BLANK_SPACE}  | ::       /::__  ::| ::__  :: "          
    echo "${BLANK_SPACE}  | ::      | ::  \ ::| ::  \ :: "          
    echo "${BLANK_SPACE}  | ::      | ::::::::| :::::::  "           
    echo "${BLANK_SPACE}  | ::      | ::__  ::| ::__  :: "          
    echo "${BLANK_SPACE}  | ::      | ::  | ::| ::  \ :: "          
    echo "${BLANK_SPACE}  | ::::::::| ::  | ::| :::::::/ "          
    echo "${BLANK_SPACE}  |________/|__/  |__/|_______/  "           
    echo ""                                        
    sleep 4
    clear
    echo ""
}

function set_root_passwd(){
    echo ""
    echo "-------------------------------------------"
    echo "Please type the password for root account: "
    echo "-------------------------------------------"
    echo ""
    read -r ROOT_PASS;
    sed -i "s/change_me/${ROOT_PASS}/g" ./config_files/basic_deploy.sh
    sed -i "s/change_me/${ROOT_PASS}/g" ./config_files/init_workers.sh
    clear
}

function start_vagrant(){
    echo ""
    echo "----------------"
    echo "Vagrant Starting"
    echo "----------------"
    echo ""
    vagrant up
}

function start_cluster(){
    echo ""
    echo "-----------------"
    echo "Vagrant Starting!"
    echo "-----------------"
    echo ""
    vagrant up
    echo "---------------------------------"
    echo "CLUSTER ON LINE! \0/ HAVE A FUN!!!"
    echo "---------------------------------"
    echo ""
}

function after_install(){
    ROOT_PASS=$(cat ./config_files/init_workers.sh|grep ROOT_PASS |awk 'NR==1{print $1}' |cut -d "=" -f2|sed -e 's/^"//' -e 's/"$//')
    echo ""
    echo "--------------------------------------------------------------"
    echo "Ohh very nice, your cluster is on line"
    echo "Now, we starting the config for access the cluster with kubctl"
    echo "--------------------------------------------------------------"
    echo ""
    sudo apt-get update 
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    sudo apt-get install -y kubelet kubeadm kubectl sshpass
    sudo apt-mark hold kubelet kubeadm kubectl
    ssh-keygen -f "/home/ph/.ssh/known_hosts" -R "172.10.10.100"
    mv "$HOME"/.kube/config "$HOME"/.kube/bkp_config
    echo "$ROOT_PASS"
    sleep 10
    sshpass -p "$ROOT_PASS" ssh -v -o StrictHostKeyChecking=no root@172.10.10.100 "cat /home/vagrant/.kube/config" |tee -a > "$HOME"/.kube/config

    echo ""
    echo "------------------------------------------------------"
    echo "Your machine is configured and connected on cluter lab"
    echo "------------------------------------------------------"
    echo ""
    kubectl get svc,deployment,pods --all-namespaces
}

function k8s_dashboard(){
    echo ""
    echo "-----------------------------------------"
    echo "Now, we install the dash board for cluster"
    echo "-----------------------------------------"
    echo ""
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml
    
    echo "-----------------------------------------"
    echo "Generating token for dash board          "
    echo "-----------------------------------------"
    echo ""
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF
    cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
    TOKEN=$(kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}")
    echo "---------------------------------------------"
    echo "Your token for access de dash board:         "
    echo "---------------------------------------------"
    echo "$TOKEN                                       "
    echo "---------------------------------------------"
    echo ""
    echo "---------------------------------------------------------------------------------------------------------------"
    echo "You can access dash board url by link                                                                   "
    echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
    echo "---------------------------------------------------------------------------------------------------------------"
    echo ""
    kubectl proxy

}

function start(){
    clear
    welcome;
    validate_pre-req;
    echo ""
    echo "-------------------------------------------------------"
    echo "Welcome, this the first menu for help you to configure "
    echo "your lab, for that we need some information            "
    echo "-------------------------------------------------------"
    echo ""
    sleep 2
    echo "-----------------------------------------------"
    echo "In first...                                    "
    echo "This a NEW instalation for starting your study,"
    echo "Or do you want only start a configured cluster?"
    echo "-----------------------------------------------"
    echo ""
    echo "-------------------------------"
    echo "Please choise bellow a option: "
    echo "-------------------------------"
    echo ""
    echo "------------------------------"
    echo "1 - New instalation."
    echo "2 - Just start my k8s cluster."
    echo "------------------------------"
    echo ""
    read -r INPUT_STRING_1;
        case $INPUT_STRING_1 in
        1)
        echo ""
        echo "-----------------"
        echo "Show!!Let's start"
        echo "-----------------"
        echo ""
        restore_config_file;
        set_root_passwd;
        start_vagrant;
        after_install;
        k8s_dashboard;
        ;;
        2)
        echo ""
        echo "--------------------------"
        echo "OK, cluster k8s starting"
        echo "--------------------------"
        echo ""
        start_cluster;
        k8s_dashboard;
        ;;
        *)
        echo ""
        echo "---------------------------------"
        echo "Ops, something is wrong try again"
        echo "---------------------------------"
        echo ""
        exit
        ;;
        esac
}

#lab_test;
start;




