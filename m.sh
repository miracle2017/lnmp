#!/usr/bin/env bash

#common part
init_dir=`pwd`
echo $init_dir
install_dir=/usr/local
wget_cnf=" -c -t 1000 "

read -p "welcome来到一键安装mysql; 按下任意键开始..." action

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
mysql_ver=`echo $mysql_name | grep -P 'mysql[0-9\.-]*' -o | sed 's/\.[0-9]*-//g'`
cd $init_dir
mv $mysql_name  $install_dir/$mysql_ver
cd $install_dir/$mysql_ver
mysql_cnf="bin/mysqld --initialize-insecure --user=mysql --basedir=$install_dir/$mysql_ver --datadir=$install_dir/$mysql_ver/data"
$mysql_cnf
cd support-files
cp mysql.server ./$mysql_ver
chmod +x $mysql_ver
sed -i "s|basedir=*|basedir=$install_dir/$mysql_ver|;s|datadir=*|datadir=$install_dir/$mysql_ver/data|"  $mysql_ver
mv $mysql_ver /etc/init.d/

echo -e "\nmysql install complete"

