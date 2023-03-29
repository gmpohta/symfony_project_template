DB_CONTAINER=db
DB_DOCKER=docker exec ${DB_CONTAINER}
DB_NAME=${DOCKER_POSTGRESQL_DB_NAME}
DB_USER=${DOCKER_POSTGRESQL_USER}
PSQL=${DB_DOCKER} psql -U postgres $(if $(1),-d $(1)) $(if $(2),-c '$(2)')

.ONESHELL:

docker-db-ok:
	@if test `docker inspect --format="{{.State.Running}}" ${DB_CONTAINER}` = 'true';\
		then echo [OK] Контейнер БД запущен;\
	else
		echo [ERROR] Контейнер БД не запущен! && exit 1;\
	fi
.PHONY: docker-db-ok

docker-db-exists: docker-db-ok
	$(call PSQL,${DB_NAME},SELECT NOW())
	test 0 = $$? && echo [OK] БД существует;
.PHONY: docker-db-exists

docker-db-recreate: docker-db-ok
	$(call PSQL) -c 'DROP DATABASE IF EXISTS ${DB_NAME}'
	$(call PSQL) -c 'CREATE DATABASE ${DB_NAME} OWNER ${DB_USER}'
.PHONY: docker-db-recreate

docker-db-schema: docker-db-exists
	docker-compose run --rm php-fpm php bin/console doctrine:schema:create --no-interaction
.PHONY: docker-db-schema

docker-init-db: docker-db-recreate docker-db-schema
.PHONY: docker-init-db