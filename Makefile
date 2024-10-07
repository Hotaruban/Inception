DATA_PATH := /home/$(USER)/data/
WP_PATH := $(DATA_PATH)/wordpress/
DB_PATH := $(DATA_PATH)/mariadb/

ENV_PATH = ./srcs/.env
COMPOSE_FILE := ./srcs/docker-compose.yml

all: setup run

setup:
	@echo "Setting up the environment..."
	@sudo mkdir -p $(WP_PATH) $(DB_PATH)

run:
	@echo "Running the services..."
	@docker-compose --env-file $(ENV_PATH) -f $(COMPOSE_FILE) up --build -d && \
	echo "Services are up and running." || \
	echo "Error: Unable to run the services."

stop:
	@echo "Stopping the services..."
	@sudo docker-compose -f $(COMPOSE_FILE) down

restart: stop run

list:
	@echo "List of services running..."
	@sudo docker ps

volume:
	@echo "List of volumes..."
	@sudo docker volume ls

clean:
	@echo "Cleaning up the environment..."
	@sudo docker-compose -f $(COMPOSE_FILE) down
	@sudo rm -rf $(WP_PATH)
	@sudo rm -rf $(DB_PATH)

re: clean all

#ultra: docker stop $(docker ps -qa); docker rm
#		$(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker
#		network rm $(docker network ls -q) 2>/dev/null"

prune:
	@echo "Pruning the environment..."
	@sudo docker system prune -a

.PHONY: all setup run stop restart list volume clean re ultra prune
