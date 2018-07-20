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
    dockerMachineName="${dockerMachineName:-Docker}"

    eval "$(docker-machine env ${dockerMachineName})"
fi

if promptYN "Do you use Amazon ECR?"; then
    echo "Please enter the following information!"

    read -p "Region: " region
    region="${region:-eu-central-1}"
    eval $(aws ecr get-login --no-include-email --region ${region})

    read -p "URL: " url
    url="${url:-493499581187.dkr.ecr.eu-central-1.amazonaws.com}"
else
    echo "Please enter the following information of your private docker registry!"

    read -p "URL: " url
    read -p "Username: " username
    read -s -p "Password: " password

    docker login --username ${username} --password ${password} ${url}
fi

nginxPrefix=""

if promptYN "Do you use private-nginx?"; then
    nginxPrefix="private-"
fi


docker build --build-arg APPLICATION=glue -t ${url}/fond-of-spryker/glue:1.13.8 ${nginxPrefix}nginx/ --no-cache
docker push ${url}/fond-of-spryker/glue:1.13.8

docker build --build-arg APPLICATION=yves -t ${url}/fond-of-spryker/yves:1.13.8 ${nginxPrefix}nginx/ --no-cache
docker push ${url}/fond-of-spryker/yves:1.13.8

docker build --build-arg APPLICATION=zed -t ${url}/fond-of-spryker/zed:1.13.8 ${nginxPrefix}nginx/ --no-cache
docker push ${url}/fond-of-spryker/zed:1.13.8

docker build -t ${url}/fond-of-spryker/php-fpm:7.1 php-fpm/ --no-cache
docker push ${url}/fond-of-spryker/php-fpm:7.1

docker build -t ${url}/fond-of-spryker/php-fpm:7.1-jenkins php-fpm/dev-and-jenkins/ --file php-fpm/dev-and-jenkins/Dockerfile.jenkins --no-cache
docker push ${url}/fond-of-spryker/php-fpm:7.1-jenkins

docker build -t ${url}/fond-of-spryker/php-fpm:7.1-dev php-fpm/dev-and-jenkins/ --file php-fpm/dev-and-jenkins/Dockerfile.dev --no-cache
docker push ${url}/fond-of-spryker/php-fpm:7.1-dev

docker build -t ${url}/fond-of-spryker/php-fpm:7.1-xdebug php-fpm/xdebug/ --no-cache
docker push ${url}/fond-of-spryker/php-fpm:7.1-xdebug