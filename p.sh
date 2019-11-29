#!/usr/bin/env bash

#common part
init_dir=`pwd`
echo $init_dir
install_dir=/usr/local
wget_cnf=" -c -t 1000 "

read -p "welcome来到一键安装php; 按下任意键开始..." action

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
php_cnf="./configure --prefix=$install_dir/$php_name --with-config-file-path=$install_dir/$php_name/etc --enable-fpm --enable-mbstring --enable-pdo --with-curl --disable-debug --disable-rpath --enable-inline-optimization --with-bz2  --enable-zip --without-libzip --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysqli --with-gd --with-jpeg-dir --with-freetype-dir --enable-calendar --with-openssl"
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






