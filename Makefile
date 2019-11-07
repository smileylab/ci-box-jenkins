build:
	docker-compose build

install:
	systemctl enable jenkins-docker.service

run: build
	docker-compose up

start: build
	docker-compose up -d

stop:
	docker-compose stop

status:
	docker-compose ps

restart:
	docker-compose stop
	docker-compose up -d

clean:
	docker-compose down

.PHONY: install run start stop status restart clean
