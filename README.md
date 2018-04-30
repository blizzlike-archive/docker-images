# blizzlike related docker images

this repo contains serveral dockerfiles for specific usecases

## images

| name             | description                                   |
| ---------------- | --------------------------------------------- |
| buildenv:stretch | debian stretch based development environment  |
| buildenv:trusty  | ubuntu trusty based development environment   |
| webhook2discord  | a webhook wrapper to push messages to discord |
| core-realmd      | mmorpg realmd server                          |
| core-mangosd     | mmorpg world server                           |

## howto

    # your user has to be in the docker group
    gpasswd -a <user> docker

### buildenv

    # build dev env
    make buildenv-stretch
    make buildenv-trusty

    # run container
    # you have to set $DEV_DIR to your development directory
    make run
    docker exec -it core-dev /bin/su core
