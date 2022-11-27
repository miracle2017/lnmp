#!/usr/bin/env bash

#common part
init_dir=`pwd`
echo $init_dir
install_dir=/usr/local
wget_cnf=" -c -t 1000 "

read -p "welcome来到一键安装nginx; 按下任意键开始..." action

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

nginx_url="https://nginx.org/download/nginx-1.16.1.tar.gz"

function download_nginx_dependence(){
    echo -e "download nginx dependence..."
    pcre_url="https://ftp.exim.org/pub/pcre/pcre-8.43.tar.gz"
    zlib_url="http://zlib.net/fossils/zlib-1.2.11.tar.gz"
    openssl_url="https://ftp.openssl.org/source/old/1.1.0/openssl-1.1.0l.tar.gz"
    wget -q $wget_cnf $pcre_url && tar -xf pcre*.tar.gz && rm -rf pcre*.tar.gz && pcre_name=`ls | grep pcre`
    wget -q $wget_cnf $zlib_url && tar -xf zlib*.tar.gz && rm -rf zlib*.tar.gz && zlib_name=`ls | grep zlib`
    wget -q $wget_cnf $openssl_url && tar -xf openssl*.tar.gz && rm -rf openssl*.tar.gz && openssl_name=`ls | grep openssl`
}

wget $wget_cnf  $nginx_url && tar -xf nginx*tar.gz && rm -rf nginx*tar.gz && nginx_name=`ls | grep nginx`
download_nginx_dependence
nginx_cnf="./configure --prefix=/usr/local/$nginx_name --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-select_module --with-poll_module --with-pcre=$init_dir/$pcre_name --with-zlib=$init_dir/$zlib_name --with-openssl=$init_dir/$openssl_name"
cd $init_dir/$nginx_name
$nginx_cnf && make && make install && echo -e "\nnginx install completed"