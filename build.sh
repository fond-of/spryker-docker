#!/bin/sh
set -e

promptYN () {
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

if promptYN "Do you use docker-machine?"; then
    read -p "Please enter the name of your docker-machine: " dockerMachineName

    eval "$(docker-machine env ${dockerMachineName})"
fi

echo "Please enter the following information of your private docker registry!"
read -p "URL: " url
read -p "Username: " username
read -s -p "Password: " password

docker login --username ${username} --password ${password} ${url}
docker build --build-arg APPLICATION=yves -t ${url}/docker/spryker-nginx:1.13.8-yves nginx/
docker build --build-arg APPLICATION=zed -t ${url}/docker/spryker-nginx:1.13.8-zed nginx/
docker build -t ${url}/docker/spryker-php-fpm:7.1 php-fpm/
docker build -t ${url}/docker/spryker-php-fpm:7.1-xdebug php-fpm/xdebug/

docker push ${url}/docker/spryker-nginx:1.13.8-yves
docker push ${url}/docker/spryker-nginx:1.13.8-zed
docker push ${url}/docker/spryker-php-fpm:7.1
docker push ${url}/docker/spryker-php-fpm:7.1-xdebug