DEV_DIR?="${HOME}/development"

all: debian ubuntu

debian: buildenv-debian

ubuntu: buildenv-ubuntu

buildenv-debian:
	docker build -t blizzlike/buildenv:stretch -f buildenv/stretch/Dockerfile .

buildenv-ubuntu:
	docker build -t blizzlike/buildenv:trusty -f buildenv/trusty/Dockerfile .

run:
	docker run --name be-stretch -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:stretch tail -f /dev/null
	docker run --name be-trusty -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:trusty tail -f /dev/null

clean:
	docker stop be-stretch be-trusty || exit 0
	docker rm be-stretch be-trusty || exit 0
