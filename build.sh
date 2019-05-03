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

docker build -t ${url}/fond-of-spryker/mailcatcher:1.0.0 mailcatcher/ --no-cache
docker push ${url}/fond-of-spryker/mailcatcher:1.0.0

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

if promptYN "Do you to build nginx images with xdebug support?"; then
    suffix="xdebug"

    docker build --build-arg APPLICATION_SUFFIX=${suffix} --build-arg APPLICATION=glue -t ${url}/fond-of-spryker/glue:1.13.8-${suffix} ${nginxPrefix}nginx/ --no-cache
    docker push ${url}/fond-of-spryker/glue:1.13.8-${suffix}

    docker build --build-arg APPLICATION_SUFFIX=${suffix} --build-arg APPLICATION=yves -t ${url}/fond-of-spryker/yves:1.13.8-${suffix} ${nginxPrefix}nginx/ --no-cache
    docker push ${url}/fond-of-spryker/yves:1.13.8-${suffix}

    docker build --build-arg APPLICATION_SUFFIX=${suffix} --build-arg APPLICATION=zed -t ${url}/fond-of-spryker/zed:1.13.8-${suffix} ${nginxPrefix}nginx/ --no-cache
    docker push ${url}/fond-of-spryker/zed:1.13.8-${suffix}
fi

versions=("7.1" "7.2")

for version in "${versions[@]}"
do
    fpmImageName="fond-of-spryker/php-fpm"
    docker build -t ${url}/${fpmImageName}:${version} php/${version}/fpm --no-cache
    docker push ${url}/${fpmImageName}:${version}

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${fpmImageName} -t ${url}/${fpmImageName}:${version}-jenkins php/${version}/fpm/dev-and-jenkins/ --file php/${version}/fpm/dev-and-jenkins/Dockerfile.jenkins --no-cache
    docker push ${url}/${fpmImageName}:${version}-jenkins

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${fpmImageName} -t ${url}/${fpmImageName}:${version}-dev php/${version}/fpm/dev-and-jenkins/ --file php/${version}/fpm/dev-and-jenkins/Dockerfile.dev --no-cache
    docker push ${url}/${fpmImageName}:${version}-dev

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${fpmImageName} -t ${url}/${fpmImageName}:${version}-xdebug php/${version}/fpm/xdebug/ --no-cache
    docker push ${url}/${fpmImageName}:${version}-xdebug

    cliImageName="fond-of-spryker/php-cli"
    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${fpmImageName} -t ${url}/${cliImageName}:${version} php/${version}/cli --no-cache
    docker push ${url}/${cliImageName}:${version}

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${cliImageName} -t ${url}/${cliImageName}:${version}-dev php/${version}/cli/dev --no-cache
    docker push ${url}/${cliImageName}:${version}-dev

    docker build --build-arg FROM_REGISTRY=${url} --build-arg FROM_IMAGE_NAME=${cliImageName} -t ${url}/${cliImageName}:${version}-xdebug php/${version}/cli/xdebug --no-cache
    docker push ${url}/${cliImageName}:${version}-xdebug
done