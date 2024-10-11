DATA_PATH := /home/$(USER)/data/
WP_PATH := $(DATA_PATH)/wordpress/
DB_PATH := $(DATA_PATH)/mariadb/

ENV_PATH = ./srcs/.env
COMPOSE_FILE := ./srcs/docker-compose.yml

all: setup run

setup:
	@echo "Setting up the environment..."
	@sudo mkdir -p $(WP_PATH) $(DB_PATH)
	@sudo mkdir -p ./secrets
	@sudo chmod 777 ./secrets

run: setup
	@echo "Running the services..."
	@bash ./srcs/requirements/tools/credentials.sh && \
	bash ./srcs/requirements/tools/create_env.sh && \
	docker-compose --env-file $(ENV_PATH) -f $(COMPOSE_FILE) up --build -d && \
	echo "Services are up and running." || \
	echo "Error: Unable to run the services."

stop:
	@echo "Stopping the services..."
	@sudo docker-compose -f $(COMPOSE_FILE) down

restart: stop run

list:
	@echo "List of services running..."
	@sudo docker ps -a

volume:
	@echo "List of volumes..."
	@sudo docker volume ls

clean:
	@echo "Cleaning up the environment..."
	@sudo docker-compose -f $(COMPOSE_FILE) down
	@sudo docker stop $(docker ps -qa) 2>/dev/null || true
	@sudo docker rm $(docker ps -qa) 2>/dev/null || true
	@sudo docker rmi -f $(docker images -qa) 2>/dev/null || true
	@sudo docker volume rm $(docker volume ls -q) 2>/dev/null || true
	@sudo docker network rm $(docker network ls -q) 2>/dev/null || true
	@sudo rm -rf $(DATA_PATH)
	@sudo rm -rf ./srcs/.env
	@sudo rm -rf ./secrets

prune:
	@echo "Pruning the environment..."
	@sudo docker system prune -a

.PHONY: setup run restart list volume clean prune
