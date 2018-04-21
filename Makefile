all: lightshope

lightshope:
	docker build -t lightshope:dev -f debian/lightshope/Dockerfile .
