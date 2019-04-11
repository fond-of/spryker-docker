# Docker Images Spryker
![license](https://img.shields.io/github/license/mashape/apistatus.svg)

# Docker Compose (only for OXS now)
Steps before using Docker Compose:
1. Run build.sh
    ```
    $ chmod +x build.sh
    $ ./build.sh
    ```
2. Run nfs_for_native_docker.sh
    ```
    $ chmod +x nfs_for_native_docker.sh
    $ ./nfs_for_native_docker.sh
    ```
3. Copy the following files to the spryker project dir
    ```
    $ cp ./docker-compose.yml.dist /path/to/spryker/project/dir/
    $ cp ./*.env.dist /path/to/spryker/project/dir/
    ```
4. Prepare copied dist files
5. Remove .dist extension from copied files
6. Run automated Nginx Reverse Proxy for Docker
    ```
    $ docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --restart=always jwilder/nginx-proxy
    ´´´
7. Add entries to host file
    ```
    DOCKER_HOST_IP      dev.domain.com
    DOCKER_HOST_IP      glue.dev.domain.com
    DOCKER_HOST_IP      zed.dev.domain.com
    DOCKER_HOST_IP      jenkins.dev.domain.com
    DOCKER_HOST_IP      rabbitmq.dev.domain.com
    DOCKER_HOST_IP      elasticsearch.dev.domain.com
    ´´´
After these steps have been completed, run the following command in the spryker project dir:
    ```
    $ docker-compose up
    ´´´