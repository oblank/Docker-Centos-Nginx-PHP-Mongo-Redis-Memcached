#vim:set ft=dockerfile:
FROM centos:latest

MAINTAINER oBlank <dyh1919@gmail.com>

# Add the ngix and PHP dependent repository
ADD ./files/nginx.repo /etc/yum.repos.d/nginx.repo

# Installing nginx
RUN yum -y install nginx perl

# Installing PHP
RUN yum -y --enablerepo=remi,remi-php56 install nginx \
        php-fpm php-mysql php-mcrypt php-curl php-cli php-gd php-pgsql php-pdo \
        php-common php-json php-pecl-redis php-pecl-memcache php-pecl-memcached nginx python-pip \
        vim telnet git php-mbstring php-pecl-xdebug php-soap php-yaml && \
        yum clean all


# Installing supervisor
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install supervisor supervisor-stdout


# Supervisor config
#RUN /usr/bin/pip install supervisor supervisor-stdout

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


COPY ./files/conf.d /etc/nginx/conf.d
COPY ./files/nginx.conf /etc/nginx/nginx.conf
COPY ./files/php.ini /etc/php.ini
COPY ./files/php-fpm.conf /etc/php-fpm.conf
COPY ./files/php-fpm.d /etc/php-fpm.d
COPY ./files/php.d/15-xdebug.ini /etc/php.d/15-xdebug.ini
COPY ./files/supervisord.conf /etc/supervisord.conf

# Adding the default file
ADD ./files/index.php /data/www/htdocs/index.php

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session
VOLUME /data/www/htdocs/


# mongodb (2.4.9)
RUN rpm -ivh http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/RPMS/mongo-10gen-2.4.14-mongodb_1.x86_64.rpm http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/RPMS/mongo-10gen-server-2.4.14-mongodb_1.x86_64.rpm
RUN echo 'smallfiles = true' >> /etc/mongod.conf # make journal small
RUN /etc/init.d/mongod start && /etc/init.d/mongod stop

# memcached (1.4.4-3.el6)
RUN echo "NETWORKING=yes" >/etc/sysconfig/network
RUN yum -y install memcached
RUN /etc/init.d/memcached start && /etc/init.d/memcached stop

# mysql (6.0.11)
RUN rpm -ivh http://mirrors.sohu.com/mysql/MySQL-6.0/MySQL-server-6.0.11-0.glibc23.x86_64.rpm
#RUN yum -y install mysql-server
RUN /etc/init.d/mysqld start && /etc/init.d/mysqld stop

# redis (2.8.6)
RUN wget http://download.redis.io/releases/redis-2.8.6.tar.gz && tar xzf redis-2.8.6.tar.gz && cd redis-2.8.6 && make && make install
RUN sed 's/daemonize no/daemonize yes/' redis-2.8.6/redis.conf > /etc/redis.conf

# Chat Server


# Expose Ports
# nginx
EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]
