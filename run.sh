#!/usr/bin/env bash
docker run -d --name test-huaxi -p 8082:80 -p 3014:3014 -p 3050:3050 -p 3051:3051 -p 4050:4050 -p 4051:4051 -p 6050:6050 -p 6051:6051 -v /data/www/htdocs/huaxi:/htdocs daocloud.io/oblank/centos-ngmmmrn:master-da22beb

# docker exec -i -t test-huaxi bash


docker run -d --name test-huaxi -p 8082:80 -p 3014:3014 -p 3050:3050 -p 3051:3051 -p 4050:4050 -p 4051:4051 -p 6050:6050 -p 6051:6051 -v /data/www/htdocs/huaxi:/htdocs daocloud.io/oblank/centos-ngmmmrn:master-init
