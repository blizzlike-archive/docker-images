# blizzlike related docker images

this repo contains serveral dockerfiles for specific usecases

## images

| path           | description             |
| -------------- | ----------------------- |
| core/dev       | development environment |

## howto

    # your user has to be in the docker group
    gpasswd -a <user> docker

    # build container
    make all # build all

### lightshope-dev

    # build dev env
    make core-dev

    # run container
    # you have to set $DEV_DIR to your development directory
    # additionally you should set a symlink to lh-core source directory
    make run
    docker exec -it core-dev /bin/su core
    ln -s /home/core/development/<path/to/core /home/core/core
    cma # cmake with predefined arguments
    make -jn # replace n for the number of cores/threads you want to use
    make install
