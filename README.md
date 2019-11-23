# linux下: nginx + php + mysql 一键安装脚本

### 目录结构
  - lnmp.sh : 安装 nginx + php + mysql 环境
  - n.sh : 单独安装nginx
  - p.sh : 单独安装php
  - m.sh : 单独安装mysql
  
### 使用
  根据自己需要在linux上运行相应脚本, 如安装nginx; 输入 ./n.sh 然后按下任意键开始, 然后耐心等待其安装完成
  
### 说明
   - 程序安装目录一律放在/usr/local下
   - 程序已经加入系统服务, 可以使用service命令控制, 程序名为程序加上版本号, 具体到/etc/init.d/目录下查看程序名, 例如安装了mysql-5.7, 那么就可以使用 service mysql-5.7 {start|stop|restart|reload|force-reload|status} 对程序进行相应的控制 
   

##### 如果你对手动安装感兴趣, 或想知道安装时都做了什么?  [可参照此教程](http://www.softeng.cn/?p=156)
  
  
