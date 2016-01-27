#vim:set ft=dockerfile:
FROM centos:latest

MAINTAINER oBlank <dyh1919@gmail.com>

# Add the ngix and PHP dependent repository
ADD ./files/nginx.repo /etc/yum.repos.d/nginx.repo

# Installing nginx
RUN yum -y install nginx

# Installing PHP
RUN yum -y --enablerepo=remi,remi-php56 install nginx \
        php-fpm php-mysql php-mcrypt php-curl php-cli php-gd php-pgsql php-pdo \
        php-common php-json php-pecl-redis php-pecl-memcache nginx python-pip \
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
ADD ./files/index.php /var/www/index.php

# Volumes
VOLUME /var/log
VOLUME /var/lib/php/session

# Expose Ports
EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]
