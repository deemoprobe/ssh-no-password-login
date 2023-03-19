# README

脚本适用场景：

- 仅适用于主机root密码相同的情况，不同请优化脚本
- 适用于Redhat/Centos发行版系统之间批量设置免密登录，其他发行版稍作更改即可。如果是不同发行版直接需要免密登陆，则在expect包安装的操作上加上发行版类型判定即可
- 脚本中排除了为本机添加公钥免密登陆和传文件的操作，这是很有必要的，不排除则有可能在脚本执行过程中卡住

涉及文件：

- iplist：主机清单文件，要配置互相免密的所有主机，包括本机
- ssh_no_pwd_login.sh：实现本机到其他机器免密登陆的脚本
- trans_script_and_run.sh：文件传输和发起执行的脚本

操作步骤如下:

```bash
# 1.任意一台机器创建/root/bin/ssh目录，把脚本和主机清单文件放进去
mkdir -pv /root/bin/ssh
# 2.修改两个脚本中PASSWORD字段的密码为自己的密码
PASSWORD="YOUR_PASSWORD"
# 3.执行trans_script_and_run.sh脚本
sh trans_script_and_run.sh
```

> 说明：如果仅需实现某一台机器到其他机器的免密登陆，仅需在那台机器执行ssh_no_pwd_login.sh脚本即可

