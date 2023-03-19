# !/bin/bash
# 获取本机IP
LOCAL_IP=`ip a | grep -w inet | grep -v 127 | awk '{print $2}' | awk -F'/' '{print $1}'`
# 获取本机外的主机清单，iplist文件放在该脚本同级目录
# 注意此处sed消除空格，不然输出的主机后会带有空格
SERVERS=`sed s/[[:space:]]//g /root/bin/ssh/iplist | grep -v $LOCAL_IP`

PASSWORD="YOUR_PASSWORD" # 修改为自己的密码

# 将脚本传入其他机器并执行，实现所有机器之间的免密登陆

for SERVER in $SERVERS
do
    # 安装expect包
    yum -y install expect 1> /dev/null
    # 批量创建文件夹
    echo 'no this dir and then will create it.'
    expect -c "set timeout -1;
        spawn ssh root@$SERVER mkdir -p /root/bin/ssh
    expect {
        *password:* {send -- $PASSWORD\r;exp_continue;}
        *yes/no* {send -- yes\r;exp_continue;}
        eof         {exit 0;}
    }"
    # 复制脚本和主机清单
    expect -c "set timeout -1;
        spawn scp /root/bin/ssh/ssh_no_pwd_login.sh $SERVER:/root/bin/ssh
    expect {
        *password:* {send -- $PASSWORD\r;exp_continue;}
        *yes/no* {send -- yes\r;exp_continue;}
        eof         {exit 0;}
    }"
    expect -c "set timeout -1;
        spawn scp /root/bin/ssh/iplist $SERVER:/root/bin/ssh
    expect {
        *password:* {send -- $PASSWORD\r;exp_continue;}
        *yes/no* {send -- yes\r;exp_continue;}
        eof         {exit 0;}
    }"
    # 执行脚本
    expect -c "set timeout -1;
        spawn ssh root@$SERVER sh /root/bin/ssh/ssh_no_pwd_login.sh
    expect {
        *password:* {send -- $PASSWORD\r;exp_continue;}
        *yes/no* {send -- yes\r;exp_continue;}
        eof         {exit 0;}
    }"
done
