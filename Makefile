DEV_DIR?="${HOME}/development"

all: core-dev

core-dev:
	docker build -t core:dev -f core/dev/Dockerfile .

run:
	docker run --name core-dev -d -v ${DEV_DIR}:/home/core/development core:dev tail -f /dev/null

clean:
	docker stop core-dev || exit 0
	docker rm core-dev || exit 0
