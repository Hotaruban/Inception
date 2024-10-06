DATA_PATH := /home/$(USER)/data/
WP_PATH := $(DATA_PATH)/wordpress/
DB_PATH := $(DATA_PATH)/mariadb/

ENV_PATH = ./srcs/.env
COMPOSE_FILE := ./srcs/docker-compose.yml

all: setup run

setup:
	@echo "Setting up the environment..."
	@sudo usermod -aG docker $(USER)
	@sudo mkdir -p $(WP_PATH) $(DB_PATH)
	@chown -R $(USER):$(USER) $(WP_PATH) $(DB_PATH)

run:
	@echo "Running the services..."
	@docker-compose --env-file $(ENV_PATH) -f $(COMPOSE_FILE) up --build -d

stop:
	@echo "Stopping the services..."
	@docker-compose -f $(COMPOSE_FILE) down

restart: stop run

list:
	@echo "List of services running..."
	@docker ps

volume:
	@echo "List of volumes..."
	@docker volume ls

clean:
	@echo "Cleaning up the environment..."
	@docker-compose -f $(COMPOSE_FILE) down
	@rm -rf $(WP_PATH)
	@rm -rf $(DB_PATH)

re: clean all

prune:
	@echo "Pruning the environment..."
	@docker system prune -a

.PHONY: all setup run stop restart list volume clean re prune
