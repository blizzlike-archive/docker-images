DEV_DIR?="${HOME}/development"

all: lightshope-dev

lightshope-dev:
	docker build -t lightshope:dev -f lightshope/dev/Dockerfile .

run:
	docker run --name lhdev -d -v ${DEV_DIR}:/home/lh/development lightshope:dev tail -f /dev/null

clean:
	docker stop lhdev || exit 0
	docker rm lhdev || exit 0
