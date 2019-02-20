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

versions=("7.1" "7.2")

for version in "${versions[@]}"
do
    imageName="fond-of-spryker/php-fpm"
    docker build -t ${url}/${imageName}:${version} php/${version}/fpm --no-cache
    docker push ${url}/${imageName}:${version}

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version}-jenkins php/${version}/fpm/dev-and-jenkins/ --file php/${version}/fpm/dev-and-jenkins/Dockerfile.jenkins --no-cache
    docker push ${url}/${imageName}:${version}-jenkins

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version}-dev php/${version}/fpm/dev-and-jenkins/ --file php/${version}/fpm/dev-and-jenkins/Dockerfile.dev --no-cache
    docker push ${url}/${imageName}:${version}-dev

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version}-xdebug php/${version}/fpm/xdebug/ --no-cache
    docker push ${url}/${imageName}:${version}-xdebug

    imageName="fond-of-spryker/php-cli"
    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version} php/${version}/cli --no-cache
    docker push ${url}/${imageName}:${version}

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version}-dev php/${version}/cli/dev --no-cache
    docker push ${url}/${imageName}:${version}-dev

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${imageName} -t ${url}/${imageName}:${version}-xdebug php/${version}/cli/xdebug --no-cache
    docker push ${url}/${imageName}:${version}-xdebug
done