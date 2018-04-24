DEV_DIR?="${HOME}/development"

all: buildenv-debian

buildenv-debian:
	docker build -t blizzlike/buildenv:stretch -f buildenv/stretch/Dockerfile .

run:
	docker run --name be-stretch -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:stretch tail -f /dev/null

clean:
	docker stop be-stretch || exit 0
	docker rm be-stretch || exit 0
