#!/usr/bin/env bash

#common part
init_dir=`pwd`
echo $init_dir
install_dir=/usr/local
wget_cnf=" -c -t 1000 "

read -p "welcome来到一键安装$0; 按下任意键开始..." action

#check wget command is exist?
if ! command -v wget; then
   yum -y install wget
fi

#create user: www and mysql
if ! id www &> /dev/null ; then
    useradd -r -s /bin/false www
fi

if ! id mysql &> /dev/null ; then
    useradd -r -s /bin/false mysql
fi
#common part

mysql_url="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.28-linux-glibc2.12-x86_64.tar.gz"
wget $wget_cnf $mysql_url && tar -xf mysql*tar.gz && rm -rf mysql*tar.gz && mysql_name=`ls | grep mysql`
yum -y install libaio*
cd $init_dir
mysql_name=`ls | grep mysql`
mv $mysql_name  $install_dir
cd $install_dir/$mysql_name
mysql_cnf="bin/mysqld --initialize-insecure --user=mysql --basedir=$install_dir/$mysql_name --datadir=$install_dir/$mysql_name/data"
$mysql_cnf