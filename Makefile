all: lightshope

lightshope:
	docker build -t lightshope:dev -f debian/lightshope/Dockerfile .

run:
	docker run --name lightshope -d lightshope:dev tail -f /dev/null
