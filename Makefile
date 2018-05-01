DEV_DIR?="${HOME}/development"

all: core-api core-stretch buildenv w2d

buildenv: buildenv-stretch buildenv-trusty

core-api:
	docker build -t blizzlike/core-api:stable --no-cache -f core/api/Dockerfile .

core-stretch:
	docker build -t blizzlike/core-realmd:latest --no-cache -f core/realmd/Dockerfile .
	docker build -t blizzlike/core-mangosd:latest --no-cache -f core/mangosd/Dockerfile .

buildenv-stretch:
	docker build -t blizzlike/buildenv:stretch --no-cache -f buildenv/stretch/Dockerfile .

buildenv-trusty:
	docker build -t blizzlike/buildenv:trusty --no-cache -f buildenv/trusty/Dockerfile .

w2d:
	docker build -t blizzlike/webhook2discord:stable --no-cache -f webhook2discord/Dockerfile .

publish:
	docker push blizzlike/core-api:stable
	docker push blizzlike/core-realmd:latest
	docker push blizzlike/core-mangosd:latest
	docker push blizzlike/buildenv:stretch
	docker push blizzlike/buildenv:trusty
	docker push blizzlike/webhook2discord:stable

run:
	docker run --name be-stretch -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:stretch tail -f /dev/null
	docker run --name be-trusty -d -v ${DEV_DIR}:/home/core/development blizzlike/buildenv:trusty tail -f /dev/null

	docker run --name w2d -d -p 8085:80/tcp -e DISCORD_WEBHOOK_URL="${DISCORD_WEBHOOK_URL}" blizzlike/webhook2discord:stable tail -f /dev/null

clean:
	docker stop be-stretch be-trusty w2d || exit 0
	docker rm be-stretch be-trusty w2d || exit 0
