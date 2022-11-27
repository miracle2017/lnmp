#!/usr/bin/env bash

#common part
init_dir=`pwd`
echo $init_dir
install_dir=/usr/local
wget_cnf=" -c -t 1000 "

read -p "welcome来到一键安装nginx + php + mysql; 按下任意键开始..." action

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


#nginx part start
nginx_url="https://nginx.org/download/nginx-1.16.1.tar.gz"

function download_nginx_dependence(){
    echo -e "download nginx dependence..."
    pcre_url="https://ftp.exim.org/pub/pcre/pcre-8.43.tar.gz"
    zlib_url="http://zlib.net/fossils/zlib-1.2.11.tar.gz"
    openssl_url="https://ftp.openssl.org/source/old/1.1.0/openssl-1.1.0l.tar.gz"
    cd $init_dir
    wget -q $wget_cnf $pcre_url && tar -xf pcre*.tar.gz && rm -rf pcre*.tar.gz && pcre_name=`ls | grep pcre`
    wget -q $wget_cnf $zlib_url && tar -xf zlib*.tar.gz && rm -rf zlib*.tar.gz && zlib_name=`ls | grep zlib`
    wget -q $wget_cnf $openssl_url && tar -xf openssl*.tar.gz && rm -rf openssl*.tar.gz && openssl_name=`ls | grep openssl`
}

wget $wget_cnf  $nginx_url && tar -xf nginx*tar.gz && rm -rf nginx*tar.gz && nginx_name=`ls | grep nginx`
download_nginx_dependence
nginx_cnf="./configure --prefix=/usr/local/$nginx_name --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_stub_status_module --with-select_module --with-poll_module --with-pcre=$init_dir/$pcre_name --with-zlib=$init_dir/$zlib_name --with-openssl=$init_dir/$openssl_name"
cd $init_dir/$nginx_name
$nginx_cnf && make && make install && echo -e "\nnginx install completed"
#nginx part end



#php part start
function download_php_dependence(){
    echo "install download php dependence"
    yum -y install libzip libzip-dev* libmcrypt-devel mhash-devel libxslt-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel
}

php_url="https://www.php.net/distributions/php-7.3.11.tar.gz"

cd $init_dir
wget $wget_cnf $php_url && tar -xf php*tar.gz && rm -rf php*tar.gz && php_name=`ls | grep php`
download_php_dependence
echo thisis$init_dir/$php_name
cd $init_dir/$php_name
php_cnf="./configure --prefix=$install_dir/$php_name --with-config-file-path=$install_dir/$php_name/etc --enable-fpm --enable-mbstring --enable-pdo --with-curl --disable-debug --disable-rpath --enable-inline-optimization --with-bz2  --enable-zip --without-libzip --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysqli --with-gd --with-jpeg-dir --with-freetype-dir --enable-calendar  --with-openssl"
$php_cnf && make && make install && echo "php install completed"
php_ver=`echo $php_name | sed 's/[^*0-9.]//g;s/\.[0-9]*$//g'`
cp php.ini-production $install_dir/$php_name/etc/php.ini
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm$php_ver && cd /etc/init.d/  && chmod u+x php-fpm$php_ver
cd $install_dir/$php_name/etc
cp php-fpm.conf.default php-fpm.conf
cd php-fpm.d
cp www.conf.default www.conf
sed -i 's/user.*=.*nobody/user = www/g;s/group.*=.*nobody/group = www/g' www.conf

echo -e "\nphp install complete"
#php part end



#mysql part start
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

#mysql part end

