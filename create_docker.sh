#!/bin/bash
read -p "Create UserName  : " USER_NAME

read -p "Setting Password  [ default : password ] : " USER_PWD
if [ ${#USER_PWD} == 0 ] ; then
    USER_PWD="password"
fi

read -p "Setting SSH's Port  : " USER_PORT

if [ ${#USER_NAME} == 0 -o ${#USER_PORT} == 0 ] ; then
    echo "Please at least enter the user name and the port number"
    exit 0
fi

echo -e "\nYou Setting:"
echo "User: ${USER_NAME}"
echo "Password: ${USER_PWD}"
echo "Port: ${USER_PORT}"

sudo docker run -itd \
                -p $USER_PORT:22 \
                --name $USER_NAME \
                --hostname $USER_NAME \
                ubuntu:20.04

sudo docker exec -ti $USER_NAME sh -c "apt-get update && apt-get -y upgrade && apt-get install -y openssh-server"


sudo docker exec -ti $USER_NAME sh -c "echo \"root:${USER_PWD}\" | chpasswd;
                                       sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config;
                                       sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;
                                       export PATH=\"$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\";
                                       wget -P /etc/fail2ban/ https://raw.githubusercontent.com/voidful/DockerBash/master/jail.local;"

sudo docker restart $USER_NAME

sudo docker exec -ti $USER_NAME sh -c "service ssh start"

echo "Container create finish"

