#!/bin/bash
read -p "Create UserName  : " USER_NAME

read -p "Setting Password  [ default : password ] : " USER_PWD
if [ ${#USER_PWD} == 0 ] ; then
    USER_PWD="password"
fi

read -p "Setting SSH's Port  : " USER_PORT
read -p "Setting tensorboard's Port  : " TENSORBOARD_PORT

if [ ${#USER_NAME} == 0 -o ${#USER_PORT} == 0 -o ${#TENSORBOARD_PORT} == 0 ] ; then
    echo "Please at least enter the user name and the port number"
    exit 0
fi

echo -e "\nYou Setting:"
echo "User: ${USER_NAME}"
echo "Password: ${USER_PWD}"
echo "Port: ${USER_PORT}"
echo "tensorboard Port: ${TENSORBOARD_PORT}"

sudo nvidia-docker run -itd \
                -p $USER_PORT:22 \
                -p $TENSORBOARD_PORT:6006 \
                --name $USER_NAME \
                --hostname $USER_NAME \
                pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel

sudo docker exec -ti $USER_NAME sh -c "apt-get update && apt-get -y upgrade && apt-get install -y openssh-server"

sudo docker exec -ti $USER_NAME sh -c "useradd -m $USER_NAME -s /bin/bash;
                                       echo \"${USER_NAME}:${USER_PWD}\" | chpasswd;
                                       adduser $USER_NAME;
                                       echo \"export LANG=C.UTF-8\" | tee -a /home/$USER_NAME/.bashrc;
                                       wget -P /etc/fail2ban/ https://raw.githubusercontent.com/voidful/DockerBash/master/jail.local;"

sudo docker restart $USER_NAME

sudo docker exec -ti $USER_NAME sh -c "/etc/init.d/ssh start"

echo "Container create finish"