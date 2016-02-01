#!/usr/bin/env bash
docker run -d --name test-huaxi -p 8082:80 -p 3014:3014 -p 3050:3050 -p 3051:3051 -p 4050:4050 -p 4051:4051 -p 6050:6050 -p 6051:6051 -v /data/www/data/huaxi:/data daocloud.io/oblank/centos-ngmmmrn:master-08da6bb

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