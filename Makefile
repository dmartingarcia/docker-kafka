# Makefile for managing Kafka Docker environment

# Docker compose command - use docker-compose if docker compose is not available
DOCKER_COMPOSE := docker compose
KAFKA_CONTAINER := kafka1
KAFKA_BOOTSTRAP := kafka1:9092
KAFKA_BIN := /opt/kafka/bin

.PHONY: help build up down restart status logs clean clean-volumes purge \
        topics create-topic delete-topic describe-topic produce consume describe-groups cluster-status

# Display help information as default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Kafka Docker Environment Management"
	@echo "Usage:"
	@echo "  make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build the Kafka Docker image
	$(DOCKER_COMPOSE) build

up: ## Start the Kafka cluster in detached mode
	$(DOCKER_COMPOSE) up -d

down: ## Stop and remove the Kafka cluster containers
	$(DOCKER_COMPOSE) down

restart: ## Restart all Kafka cluster containers
	$(DOCKER_COMPOSE) restart

status: ## Show status of the Kafka cluster containers
	$(DOCKER_COMPOSE) ps

logs: ## Show logs from all containers
	$(DOCKER_COMPOSE) logs -f

clean: ## Stop containers and remove containers, networks, and volumes
	$(DOCKER_COMPOSE) down --volumes

clean-volumes: ## Remove all Kafka data volumes
	docker volume rm kafka-data-1 kafka-data-2 kafka-data-3 || true

purge: down clean-volumes ## Complete cleanup: stop containers and remove volumes

run: up ## Alias for 'up' command - starts the Kafka cluster

# Kafka management commands

topics: ## List all Kafka topics
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-topics.sh --list --bootstrap-server $(KAFKA_BOOTSTRAP)

create-topic: ## Create a topic. Usage: make create-topic TOPIC=topic-name PARTITIONS=3 REPLICATION=3
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-topics.sh \
		--create \
		--topic $(TOPIC) \
		--bootstrap-server $(KAFKA_BOOTSTRAP) \
		--partitions ${PARTITIONS:-3} \
		--replication-factor ${REPLICATION:-3}

delete-topic: ## Delete a topic. Usage: make delete-topic TOPIC=topic-name
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-topics.sh \
		--bootstrap-server $(KAFKA_BOOTSTRAP) \
		--delete \
		--topic $(TOPIC)

describe-topic: ## Show topic details. Usage: make describe-topic TOPIC=topic-name
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-topics.sh \
		--bootstrap-server $(KAFKA_BOOTSTRAP) \
		--describe \
		--topic $(TOPIC)

produce: ## Produce messages to a topic. Usage: make produce TOPIC=topic-name
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-console-producer.sh \
		--topic $(TOPIC) \
		--bootstrap-server $(KAFKA_BOOTSTRAP)

consume: ## Consume messages from a topic. Usage: make consume TOPIC=topic-name [FROM_BEGINNING=true]
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-console-consumer.sh \
		--topic $(TOPIC) \
		--bootstrap-server $(KAFKA_BOOTSTRAP) \
		$(if $(FROM_BEGINNING),--from-beginning,)

describe-groups: ## List and describe consumer groups
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-consumer-groups.sh \
		--describe \
		--bootstrap-server $(KAFKA_BOOTSTRAP) --all-groups

cluster-status: ## Show cluster status and controller information
	$(DOCKER_COMPOSE) exec $(KAFKA_CONTAINER) $(KAFKA_BIN)/kafka-topics.sh \
		--bootstrap-server $(KAFKA_BOOTSTRAP) --describe
