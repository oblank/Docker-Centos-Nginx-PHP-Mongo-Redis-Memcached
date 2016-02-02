Docker-Centos-Nginx-PHP-Mongo-Redis-Memcached
---------------------

Created by [@oBlank](http://twitter.com/oBlank) <br>
Website : http://www.oBlank.com<br>

Based on [docker-php56-fpm-nginx](https://github.com/CrakLabs/docker-php56-fpm-nginx), [Docker-Centos-Nginx-PHP](https://github.com/kaushalkishorejaiswal/Docker-Centos-Nginx-PHP) and [ruby と mongodb, mysql, redis, memcached を入れた docker イメージを作ったメモ](http://blog.livedoor.jp/sonots/archives/36644307.html)

## Steps for creating image from the Docker

### Step 1 : Clone by git

Command:

    git clone https://github.com/oblank/Docker-Centos-Nginx-PHP-Mongo-Redis-Memcached.git

### Step 2 : Change the directory to the clone folder

Command:

    cd Docker-Centos-Nginx-PHP-Mongo-Redis-Memcached


### Step 3 : Create the Docker Image

Command:

    sudo docker build -t ##NAME_OF_YOUR_DOCKER_IMAGE## .

**Note :**

    a). This command will be fired where the DockerFile will be placed
    b). ##NAME_OF_YOUR_DOCKER_IMAGE## : Replace it with your image name
    c). . : (.) Symbols shows that your Dockerfile is available on the same directory where you are running the command.


### Step 4 : Create an Centos, Nginx, PHP-FPM, Memcached, Redis, MongoDB, Node.js, Supervisord Installed Container from the image

Command Syntax:
    
        sudo docker run --name [container name] -p [port to access (New Port):port exposed(original port)] -i -t [image name]

Command:
        
        sudo docker run --name ##NAME_OF_YOUR_DOCKER_CONTAINER## -d -p 8082:80 ##NAME_OF_YOUR_DOCKER_IMAGE##

### Step 5 :  Now you can access your Nginx container from your web browser.

Command:
    
        http://127.0.0.1:8082/

## Some other important commands

+ **docker images :** To list all the images of your docker
+ **docker ps :** To list all the runing containers
+ **docker kill ####CONTAINER_NAME#### :** To kill the runing container</li>
+ **docker rm ####CONTAINER_NAME#### :** To delete the container from the system.
+ **docker inspect ####CONTAINER_NAME#### :** To get all the information about the container.
+ **docker logs ####CONTAINER_NAME#### :** To get the logs of the container.
+ **docker ps -a:** To get the listing of all the containers.

## Additional Notes:

Command for attaching the volume of your hosted machine:

Command Syntax:

    sudo docker run --name ##NAME_OF_YOUR_DOCKER_CONTAINER## -d -p 8082:80 -v ##HOSTED_VOLUME_LOCATION##:##CONTAINER_VOLUME_LOCATION## ##YOUR_IMAGE_NAME##


Command Example:
   
       sudo docker run --name apache_ins -d -p 8082:80 -v /var/www/kaushal:/var/www kaushal_nginx

**Important!** <code>docker rm ##CONTAINER_NAME##</code> will delete container without volume, unless you use <code>docker rm -v ##CONTAINER_NAME##</code> instead.
