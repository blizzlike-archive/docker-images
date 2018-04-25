# blizzlike related docker images

this repo contains serveral dockerfiles for specific usecases

## images

| name             | description                                   |
| ---------------- | --------------------------------------------- |
| buildenv:stretch | debian stretch based development environment  |
| buildenv:trusty  | ubuntu trusty based development environment   |
| webhook2discord  | a webhook wrapper to push messages to discord |

## howto

    # your user has to be in the docker group
    gpasswd -a <user> docker

    # build container
    make all # build all

### buildenv

    # build dev env
    make buildenv-debian
    make buildenv-ubuntu

    # run container
    # you have to set $DEV_DIR to your development directory
    make run
    docker exec -it core-dev /bin/su core
