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
    cp ./docs/bkp_files/vagrant_backup_tmp ./Vagrantfile 
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
        echo "---------------------------------------------------------------"
        echo "Nice, you have the Vagrant installed, let's go to the next step" 
        echo "---------------------------------------------------------------"
        echo "" 
    else
        echo "-------------------------------------------------------------"
        echo "Ops, virtualbox is necessary! Do you want proceed to install?" 
        echo "-------------------------------------------------------------" 
        echo ""
        echo "-------------------------------"
        echo "1 - Ok, let's go ahead."
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
            echo "-----------------------------------"
            echo "Oops! Something is wrong, try again"
            echo "-----------------------------------"
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
        echo "---------------------------------------------------------------"
        echo "Nice, you have the Vagrant installed, let's go to the next step" 
        echo "---------------------------------------------------------------"
        echo ""  
    else
        echo "----------------------------------------------------------"
        echo "Ops, Vagrant is necessary, do you want proceed to install?" 
        echo "----------------------------------------------------------" 
        echo ""
        echo "-------------------------------"
        echo "1 - Ok, let's go ahead."
        echo "2 - No, better in another time."
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
            echo "-----------------------------------"
            echo "Oops! Something is wrong, try again"
            echo "-----------------------------------"
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
    echo "-----------------------------------------------"
    echo "Please type the password for VMs root account: "
    echo "-----------------------------------------------"
    echo ""
    read -r ROOT_PASS;
    sed -i "s/change_me/${ROOT_PASS}/g" ./config_files/basic_deploy.sh
    sed -i "s/change_me/${ROOT_PASS}/g" ./config_files/init_workers.sh
    clear
}

function set_ip_network(){
    echo ""
    echo "----------------------------------------------------"
    echo "Please type the IP of network VMs (ex: 10.50.50.0): "
    echo "----------------------------------------------------"
    echo ""
    read -r IP_NETWORK;
    sed -i "s/change_me/${IP_NETWORK}/g" ./config_files/basic_deploy.sh
    sed -i "s/change_me/${IP_NETWORK}/g" ./config_files/init_workers.sh
    sed -i "s/change_me/${IP_NETWORK}/g" ./config_files/basic_deploy.sh
    sed -i "s/change_me/${IP_NETWORK}/g" ./config_files/Vagrantfile
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

function k8s_dashboard(){
    echo ""
    echo "-----------------------------------------"
    echo "Now, we install the dashboard for cluster"
    echo "-----------------------------------------"
    echo ""
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml
    
    echo "-----------------------------------------"
    echo "Generating token for dashboard          "
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
    echo "Your token for access de dashboard:         "
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


function after_install(){
    ROOT_PASS=$(cat ./config_files/init_workers.sh|grep ROOT_PASS |awk 'NR==1{print $1}' |cut -d "=" -f2|sed -e 's/^"//' -e 's/"$//')
    IP_MASTER="10.50.50.100"
    clear
    echo ""
    echo "--------------------------------------------------------------"
    echo "Ohh very nice, your cluster is on line"
    echo "Now, we starting the config for access the cluster with kubctl"
    echo "--------------------------------------------------------------"
    echo ""
    echo "----------------------------------------------------------------"
    echo "----------------------------------------------------------------"
    echo ""
    echo "Do you want to install kubeadm, kubelet and kubectl "
    echo "and configure the $HOME/.kube/config file on localhost?"
    echo ""
    echo "-----------------------------------------------------------------"
    echo "Please, type an option"
    echo ""    
    echo "1 - Yes."
    echo "2 - No."
    echo "------------------------------"
    echo ""
    read -r INPUT_STRING_1;
        case $INPUT_STRING_1 in
        1)
        echo ""
        echo "-----------------"
        echo "OK!!Let's start"
        echo "-----------------"
        echo ""
        sudo apt update
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        su - root -c "echo \"deb http://apt.kubernetes.io/ kubernetes-xenial main\" > /etc/apt/sources.list.d/kubernetes.list"
        sudo apt update
        sudo apt install -y kubelet kubeadm kubectl sshpass
        ssh-keygen -f "/home/ph/.ssh/known_hosts" -R "$IP_MASTER"
        mv "$HOME"/.kube/config "$HOME"/.kube/bkp_config
        echo "$ROOT_PASS"
        sleep 10
        sshpass -p "$ROOT_PASS" ssh -o StrictHostKeyChecking=no root@$IP_MASTER "cat /home/vagrant/.kube/config" |tee -a > "$HOME"/.kube/config
        echo ""
        echo "------------------------------------------------------"
        echo "Your machine is configured and connected on cluter lab"
        echo "------------------------------------------------------"
        echo ""
        kubectl get svc,deployment,pods --all-namespaces
        sleep 5
        k8s_dashboard;
        echo "---------------------------------------------------------------------"
        echo "If you want Turn off your cluster, press CRTL+C and type vagrant halt"
        echo "---------------------------------------------------------------------"
        echo ""
        echo "--------------------------------------------------------------------"
        echo "If you want destroy the cluster and all VMs, type vagrant destroy -f"
        echo "--------------------------------------------------------------------"
        ;;
        2)
        echo ""
        echo "-------------------------------"
        echo "OK, your cluster k8s is running"
        echo "-------------------------------"
        echo ""
        exit
        ;;
        *)
        echo ""
        echo "----------------------------------"
        echo "Oops, something is wrong try again"
        echo "----------------------------------"
        echo ""
        exit
        ;;
        esac 
}


function start(){
    clear
    welcome;
    validate_pre-req;
    echo ""
    echo "-------------------------------------------------------"
    echo "Welcome, this the first menu for help you to configure "
    echo "your lab, for that we need some information.           "
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
        echo "----------------------------------"
        echo "Oops, something is wrong try again"
        echo "----------------------------------"
        echo ""
        exit
        ;;
        esac
}

#lab_test;
start;




