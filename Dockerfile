#vim:set ft=dockerfile:
FROM centos:centos6

MAINTAINER oBlank <dyh1919@gmail.com>

# Add the ngix and PHP dependent repository
ADD ./files/nginx.repo /etc/yum.repos.d/nginx.repo

RUN yum -y update; yum clean all
# Enable Extra Packages for Enterprise Linux (EPEL) for CentOS
RUN yum -y install epel-release; yum clean all

# Installing nginx
RUN yum -y install nginx perl wget

# Installing PHP
RUN yum -y --enablerepo=remi,remi-php56 install nginx \
        php-fpm php-mysql php-mcrypt php-curl php-cli php-gd php-pgsql php-pdo \
        php-common php-json php-pecl-redis php-pecl-memcache php-pecl-memcached nginx python-pip \
        vim telnet git php-mbstring php-pecl-xdebug php-soap php-yaml && \
        yum clean all


# Supervisor config
#RUN /usr/bin/pip install supervisor supervisor-stdout

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD ./files/conf.d /etc/nginx/conf.d
ADD ./files/nginx.conf /etc/nginx/nginx.conf
ADD ./files/php.ini /etc/php.ini
ADD ./files/php-fpm.conf /etc/php-fpm.conf
ADD ./files/php-fpm.d /etc/php-fpm.d
ADD ./files/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini
ADD ./files/supervisord.conf /etc/supervisord.conf

# Adding the default file
ADD ./files/index.php /data/www/htdocs/index.php

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session
VOLUME /data/www/htdocs/


# Install MongoDB
RUN echo -e "[mongodb]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/6/mongodb-org/3.2/`uname -m`/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/mongodb.repo
RUN yum install -y mongodb-org
RUN mkdir -p /data/db
#RUN /etc/init.d/mongod start && /etc/init.d/mongod stop

# memcached (1.4.4-3.el6)
RUN echo "NETWORKING=yes" >>/etc/sysconfig/network
RUN yum -y install memcached
#RUN /etc/init.d/memcached start && /etc/init.d/memcached stop

# mysql
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum -y install mysql-community-server


# redis (2.8.6)
#RUN wget http://download.redis.io/releases/redis-2.8.6.tar.gz && tar xzf redis-2.8.6.tar.gz && cd redis-2.8.6 && make && make install
RUN yum install -y redis
RUN sed 's/daemonize no/daemonize yes/' /etc/redis.conf > /etc/redis.conf

# Chat Server
# Install Node.js and npm
RUN yum install -y nodejs npm

# cron php scripts

# Installing supervisor
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum --enablerepo=epel install -y supervisor

# Expose Ports
# Nginx
EXPOSE 80
EXPOSE 443

# Promolo
EXPOSE 3014 4050 3050 4051 3051 6050 6051

# TODO config supervisord.conf
CMD ["/usr/bin/supervisord", "-n"]
