#!/usr/bin/env bash
docker run --ulimit core=-1 --privileged -d --name test-huaxi -p 8081:8081 -p 8082:80 -p 8083:443 -p 8010:8010 -p 3014:3014 -p 3050:3050 -p 3051:3051 -p 4050:4050 -p 4051:4051 -p 6050:6050 -p 6051:6051 -v /data/www/htdocs/huaxi:/data daocloud.io/oblank/centos-ngmmmrn:master-5840356

# docker exec -i -t test-huaxi bash


#
##groups
#location /groups_encrypt/ {
#    rewrite ^/groups_encrypt/(.*)$ /tsb-server/app/webroot/$1;
#    if (-f $request_filename) {
#        break;
#    }
#    if (!-f $request_filename) {
#        rewrite ^/tsb-server/app/webroot/(.*)$ /tsb-server/app/webroot/index.php?url=$1 last;
#        break;
#    }
#}
#
#
#location ~ .*\.php$ {
#    fastcgi_pass unix:/var/run/php-fpm.sock;
#    fastcgi_index  index.php;
#    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
#
#    include        fastcgi_params;
#}


# mongo.so need install by source : https://github.com/mongodb/mongo-php-driver-legacy

# test-tsb
docker run --ulimit core=-1 --privileged -d --name test-tsb -p 9081:8081 -p 9082:80 -p 9083:443 -p 8010:8010 -p 3024:3014 -p 3060:3050 -p 3061:3051 -p 4060:4050 -p 4061:4051 -p 6060:6050 -p 6061:6051 -v /data/www/htdocs/tuishiben:/data daocloud.io/oblank/centos-ngmmmrn:master-e663b74

# test-php7
docker run --ulimit core=-1 --privileged -d --name test-php7 -p 8071:8081 -p 8070:80 -v /data/www/htdocs/huaxi-php7:/data daocloud.io/oblank/centos-ngmmmrn:master-e663b74

# test-xzt
docker run --ulimit core=-1 --privileged -d --name test-xzt -p 8072:8081 -p 8073:80 -p 8074:8010 -p 3034:3014 -p 3070:3050 -p 3071:3051 -p 4070:4050 -p 4071:4051 -p 6070:6050 -p 6071:6051 -v /data/www/htdocs/xinzt:/data daocloud.io/oblank/centos-ngmmmrn:master-e663b74

# test-bsky
docker run --ulimit core=-1 --privileged -d --name test-bsky -p 38072:8081 -p 38073:80 -p 38074:8010 -p 33034:3014 -p 33070:3050 -p 33071:3051 -v /data/www/htdocs/bashu-kuaiyi:/data daocloud.io/oblank/centos-ngmmmrn:master-e663b74