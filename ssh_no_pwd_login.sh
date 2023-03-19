#!/bin/bash

# 获取本机IP
LOCAL_IP=`ip a | grep -w inet | grep -v 127 | awk '{print $2}' | awk -F'/' '{print $1}'`
# 获取本机外的主机清单，iplist文件放在该脚本同级目录
# 注意此处sed消除空格，不然输出的主机后会带有空格
SERVERS=`sed s/[[:space:]]//g /root/bin/ssh/iplist | grep -v $LOCAL_IP`
PASSWORD="YOUR_PASSWORD" # 修改为自己的密码

auto_gen_ssh_key() {
    expect -c "set timeout -1;
        spawn ssh-keygen;
        expect {
            *(/root/.ssh/id_rsa)* {send -- \r;exp_continue;}
            *passphrase)* {send -- \r;exp_continue;}
            *again* {send -- \r;exp_continue;}
            *(y/n)* {send -- y\r;exp_continue;}
            *password:* {send -- $PASSWORD\r;exp_continue;}
            eof         {exit 0;}
        }";
}

# $1为auto_copy_id_to_all()中for循环中传参$SERVER，$2为$PASSWORD
auto_ssh_copy_id() {
        expect -c "set timeout -1;
        spawn ssh-copy-id $1;
        expect {
            *yes/no*  {send -- yes\r;exp_continue;}
            *password:* {send -- $2\r;exp_continue;}
            eof         {exit 0;}
        }";
}

auto_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

# 安装expect包
yum -y install expect 1> /dev/null
# 执行函数
auto_gen_ssh_key
auto_copy_id_to_all
