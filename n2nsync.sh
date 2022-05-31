#!/bin/bash
#An N2N Federation Configuration Syncing Tool
#Author : EchoNoch (https://github.com/ywnsya)
#Version: 0.1
. /etc/profile
. ~/.bash_profile
basepath=$(cd `dirname $0`; pwd)
echo -e "
\033[36m 
Welcome to use this script
This script synchronizes the configuration between two or more N2N federations
该脚本用于同步两个N2N Federation之间的配置

Version:0.1
\033[0m 
—————————————————————————————————————————————————————————————————————————————————
"
if [ -f "$basepath/n2nsync.config" ];then
    echo "Now Syncing"
    source $basepath/n2nsync.config
    curl -m 10 -d "ip=$thisip&type=config&passwd=$password" $ip:$port > $conf
    curl -m 10 -d "ip=$thisip&type=list&passwd=$password" $ip:$port > $list
    echo "Sync Successfully"

else
  echo "
  The configuration file does not exist 配置文件不存在
  Enter configuration guide             进入配置引导
  ___________________________________________________
  "
    echo "1.Enter the server's IP addr 输入N2Nsync服务器IP地址"
    read ip
    echo "Server's IP 服务器IP: $ip"
    echo "________________________________________________"
    echo "2. Enter the server's Port 输入N2Nsync服务器端口 (25900)"
    read port  
    if [[ "$port" = "" ]]
    then
    port=25900
    fi
    echo "Server's Port 服务器端口: $port"
    echo "________________________________________________"
    echo "3. Enter this client's public IP 输入当前服务器公网IP地址"
    echo "It is used for authentication only. If left blank, it will be automatically obtained from the server
    仅用于鉴权，留空将自动从服务器获取
    "
    read thisip
    echo "Client's public IP 本机公网IP: $thisip"
    echo "________________________________________________"
    echo "4. Enter Server's Password 输入服务器密码"
    read password
    echo "Server's Password 服务器密码: $password"
    echo "________________________________________________"
    echo "5. Enter your supernode.conf path 输入supernode.conf配置文件路径"
    echo "/etc/n2n/supernode.conf if blank  默认为/etc/n2n/supernode.conf"
    read conf
    if [[ "$conf" = "" ]]
    then
    conf='/etc/n2n/supernode.conf'
    fi
    echo "Supernode.conf path 配置文件路径: $conf"
    echo "________________________________________________"
    echo "6. Enter your community.list path 输入community.list配置文件路径"
    echo "/etc/n2n/community.list if blank  默认为/etc/n2n/community.list"
    read list
    if [[ "$list" = "" ]]
    then
    list='/etc/n2n/community.list'
    fi
    echo "community.list path   List文件路径: $conf"
    echo "________________________________________________"
    echo "
    You will connect with the Server $ip:$port use IP $thisip and password $password
    您将连接到服务器 $ip:$port 通过使用IP $thisip 密码 $password

    Supernode.conf:  $conf
    Community.list:  $list
    "
    echo "Enter 1 to test Server; Enter 2 to save this config; Enter 3 to exit"
    echo "输入1测试连接，输入2保存配置，输入3退出"
    read todo
    if [[ "$todo" = "1" ]]
    then
        pong=$(curl -m 10 -d "ip=$thisip&type=ping&passwd=$password" $ip:$port) 
        if [[ "$pong" = "pong" ]]
        then
        echo "连接成功 Connect successfully"
            echo "Do you want to save the configuration?是否保存配置?"
            echo "Enter 1 to save, 2 to exist 输入1保存，2退出"
            read todo2
            if [[ "$todo2" = "1" ]]
            then
                todo='2'
            fi
        else
        echo "连接失败 Failed to connect"
        echo "$pong"
        exit
        fi
    fi
    if [[ "$todo" = "2" ]]
    then
    touch $basepath/n2nsync.config
    echo "ip=$ip"  > $basepath/n2nsync.config
    echo "port=$port"  >> $basepath/n2nsync.config
    echo "thisip=$thisip"  >> $basepath/n2nsync.config
    echo "password=$password"  >> $basepath/n2nsync.config
    echo "conf=$conf"  >> $basepath/n2nsync.config
    echo "list=$list"  >> $basepath/n2nsync.config
    echo "Saved this configuration successfully 配置保存成功"
    echo "Do you want to add a system timing task(crontab) for synchronization?(Require root)
        是否添加一个系统定时任务crontab以实现定时同步?需要ROOT
        Enter 1 to add 输入 1 以添加一个任务
        "
    read timetask
        if [[ "$timetask" = "1" ]]
        then
            echo "How many minutes between each synchronization?
                每次同步间隔几分钟？
                Enter a number between 1 and 60
                输入1~60间的数字
                "
            read num
            echo "$num * * * * root /bin/bash $basepath/n2nsync.sh" >> /etc/crontab
            echo "Already added an timing task to sync every $num minutes"
            echo "已经添加了一个每$num分钟执行一次的定时任务"
        fi
    fi
fi