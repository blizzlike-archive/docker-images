DEV_DIR?="${HOME}/development"

all: lightshope

lightshope:
	#docker build -t lh:debian -f debian/lh/Dockerfile .
	docker build -t lh:ubuntu -f ubuntu/lh/Dockerfile .

run:
	docker run --name lh -d -v ${DEV_DIR}:/home/lh/development lh:ubuntu tail -f /dev/null

clean:
	docker stop lh || exit 0
	docker rm lh || exit 0
