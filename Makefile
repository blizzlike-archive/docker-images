DEV_DIR?="${HOME}/development"

all: debian ubuntu w2d

debian: buildenv-debian

ubuntu: buildenv-ubuntu

buildenv-debian:
	docker build -t blizzlike/buildenv:stretch -f buildenv/stretch/Dockerfile .

buildenv-ubuntu:
	docker build -t blizzlike/buildenv:trusty -f buildenv/trusty/Dockerfile .

w2d:
	docker build -t blizzlike/webhook2discord:stable --no-cache -f webhook2discord/Dockerfile .

run:
	docker run --name be-stretch -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:stretch tail -f /dev/null
	docker run --name be-trusty -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:trusty tail -f /dev/null

	docker run --name w2d -d -p 8085:80/tcp -e DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL}" blizzlike/webhook2discord:stable tail -f /dev/null

clean:
	docker stop be-stretch be-trusty w2d || exit 0
	docker rm be-stretch be-trusty w2d || exit 0
