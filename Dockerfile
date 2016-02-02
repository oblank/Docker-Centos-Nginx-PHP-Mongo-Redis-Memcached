#vim:set ft=dockerfile:
FROM centos:centos6

MAINTAINER oBlank <dyh1919@gmail.com>

# Add the ngix and PHP dependent repository
ADD ./files/nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum -y update; yum clean all
# Enable Extra Packages for Enterprise Linux (EPEL) for CentOS
RUN yum -y install epel-release; yum clean all

# Installing nginx
RUN yum -y install nginx perl wget tar

# Installing PHP
RUN rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum update -y
RUN yum install -y php56w php56w-fpm php56w-mbstring php56w-gd php56w-dom php56w-pdo php56w-mysqlnd php56w-mcrypt php56w-process php56w-pear php56w-cli php56w-xml php56w-curl php56w-pecl-memcached php56w-devel php56w-pecl-redis


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session
VOLUME /data

# Adding files
ADD ./files/conf.d /etc/nginx/conf.d
ADD ./files/nginx.conf /etc/nginx/nginx.conf
ADD ./files/php.ini /etc/php.ini
ADD ./files/php-fpm.conf /etc/php-fpm.conf
ADD ./files/php-fpm.d /etc/php-fpm.d
ADD ./files/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini
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
RUN curl -SLO "https://nodejs.org/dist/v5.5.0/node-v5.5.0-linux-x64.tar.gz" \
  && tar -xzf "node-v5.5.0-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v5.5.0-linux-x64.tar.gz"

# cron php scripts

# Installing supervisor
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum --enablerepo=epel install -y supervisor

# China Timezone
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Expose Ports
# Nginx
EXPOSE 80 443 8081

# Promolo
EXPOSE 3014 4050 3050 4051 3051 6050 6051

CMD ["/usr/bin/supervisord", "-n"]
