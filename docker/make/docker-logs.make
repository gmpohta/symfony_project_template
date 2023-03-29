.PHONY: nginx-log php-log redis-log postgresql-log 

nginx-log: 
	$(info Nginx stdout logs)
	docker-compose logs -f nginx

php-log: 
	$(info php-fpm stdout logs)
	docker-compose logs -f php-fpm

redis-log: 
	$(info Redis stdout logs)
	docker-compose logs -f redis

postgresql-log: 
	$(info PostgreSQL stdout logs)
	docker-compose logs -f db