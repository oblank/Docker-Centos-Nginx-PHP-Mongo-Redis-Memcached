#vim:set ft=dockerfile:
FROM centos:centos6

MAINTAINER oBlank <dyh1919@gmail.com>

# Add the ngix and PHP dependent repository
ADD ./files/nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum -y update; yum clean all
# Enable Extra Packages for Enterprise Linux (EPEL) for CentOS
RUN yum -y install epel-release; yum clean all

# Installing nginx
RUN yum -y install ntpdate nginx perl wget tar

# Installing PHP
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum install -y php70w libmemcached10
RUN yum install -y php70w-fpm php70w-mbstring php70w-gd php70w-dom php70w-xml php70w-pdo php70w-mysqlnd php70w-mcrypt php70w-process php70w-pear php70w-cli php70w-devel php70w-opcache
RUN sed -E -i "s/^error_log\ = \/var\/log\/php-fpm\/error.log/error_log = \/data\/logs\/php\/fpm-error.log/" /etc/php-fpm.conf
RUN sed -E -i "s/^listen\ =.+?$/listen = 0.0.0.0:9000/" /etc/php-fpm.d/www.conf
RUN sed -E -i "s/^listen.allowed_clients\ =.+?$/; listen.allowed_clients\ =\ 127\.0\.0\.1/" /etc/php-fpm.d/www.conf
RUN sed -E -i "s/^slowlog\ = \/var\/log\/php-fpm\/www-slow.log/slowlog\ =\ \/data\/logs\/php\/php-slow.log/" /etc/php-fpm.d/www.conf
RUN sed -E -i "s/^php_admin_value\[error_log\]\ =.+?$/php_admin_value\[error_log\]\ =\ \/data\/logs\/php\/php-error.log/" /etc/php-fpm.d/www.conf
RUN { \
    echo "catch_workers_output = yes"; \
} >> /etc/php-fpm.d/www.conf
RUN sed -E -i "s/^post_max_size\ =.+?$/post_max_size\ =\ 100M/" /etc/php.ini
RUN sed -E -i "s/^upload_max_filesize\ =.+?$/upload_max_filesize\ =\ 100M/" /etc/php.ini
RUN sed -E -i "s/^display_errors\ .+?$/display_errors\ =\ On/" /etc/php.ini
RUN sed -E -i "s/^error_reporting\ .+?$/error_reporting\ =\ E_ALL\ \&\ \~E_DEPRECATED\ \&\ \~E_STRICT\ \&\ \~E_NOTICE/" /etc/php.ini

ADD ./files/ext/*.ini /etc/php.d/
ADD ./files/ext/*.so /usr/lib64/php/modules/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session
VOLUME /data

# Adding files
ADD ./files/conf.d /etc/nginx/conf.d
ADD ./files/nginx.conf /etc/nginx/nginx.conf
ADD ./files/mongod.conf /etc/mongod.conf
ADD ./files/redis.conf /etc/redis.conf
ADD ./files/my.cnf /etc/my.cnf
ADD ./files/index.php /data/index.php
ADD ./files/supervisord.conf /etc/supervisord.conf

# fix mkdir not working, see issue: https://github.com/docker/docker/issues/13011
RUN bash -c 'mkdir -pv /data/db/{mongodb,mysql,redis}'

# Install MongoDB
RUN echo -e "[mongodb]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/6/mongodb-org/3.2/`uname -m`/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb.repo
RUN yum install -y mongodb-org
RUN mkdir -p /data/db/mongodb
#RUN /etc/init.d/mongod start && /etc/init.d/mongod stop

# memcached
RUN echo "NETWORKING=yes" >>/etc/sysconfig/network
RUN yum -y install memcached
#RUN /etc/init.d/memcached start && /etc/init.d/memcached stop

# mysql
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum -y install mysql-community-server
RUN mkdir -p /data/db/mysql


# redis
RUN yum install -y redis
RUN mkdir -p /data/db/redis

# Chat Server
# Install Node.js and npm
#RUN yum install -y nodejs npm
RUN curl -sL https://rpm.nodesource.com/setup_5.x | bash -
RUN yum install -y nodejs

# Install g++/gcc 4.8.2 in CentOS 6.6
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
RUN yum install -y devtoolset-2-gcc devtoolset-2-binutils
RUN yum install -y devtoolset-2-gcc-c++ devtoolset-2-gcc-gfortran
RUN /opt/rh/devtoolset-2/root/usr/bin/gcc --version
RUN scl enable devtoolset-2 bash
RUN source /opt/rh/devtoolset-2/enable

# cron php scripts
RUN yum install -y vixie-cron
RUN chkconfig --list crond
RUN chkconfig crond on
RUN sed -E -i "s/session    required   pam_loginuid.so/session    optional   pam_loginuid.so/" /etc/pam.d/crond

# Installing supervisor
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum --enablerepo=epel install -y supervisor

# China Timezone
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Expose Ports
# Nginx
EXPOSE 80 443 8081 8010

# Pomelo
EXPOSE 3014 4050 3050 4051 3051 6050 6051

CMD ["/usr/bin/supervisord", "-n"]
