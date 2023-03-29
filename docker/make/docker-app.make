up:
	docker-compose up -d --build --force-recreate
.PHONY: up

down:
	docker-compose down
.PHONY: down

docker-build-backend:
	docker-compose run --rm php-fpm composer install --no-interaction -o
.PHONY: docker-build-backend

docker-install: up docker-build-backend docker-init-db
	$(info === Проект собран и запущен ===)
.PHONY: docker-install

docker-cc:
	docker-compose run --rm php-fpm php bin/console cache:clear --no-warmup --no-debug
.PHONY: docker-build-backend

#Установить разрешения для папок, которые создал Docker
docker-set-perms: 
	docker run -v $(shell pwd):/app -w /app --rm alpine:latest find ./bin -name '.?*' -prune -o -exec chmod 777 {} +
.PHONY: docker-set-perms