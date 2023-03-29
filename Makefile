-include .env

DOCKER_RECIPES_DIR=./docker/make

-include ${DOCKER_RECIPES_DIR}/docker-app.make
-include ${DOCKER_RECIPES_DIR}/docker-db.make
-include ${DOCKER_RECIPES_DIR}/docker-logs.make
-include ${DOCKER_RECIPES_DIR}/docker-cli.make