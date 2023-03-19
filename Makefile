# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_SERVICE := php-apache

# Executables
PHP      = $(PHP_SERVICE) php
COMPOSER = $(PHP_SERVICE) composer
SYMFONY  = bin/console

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
## —— Docker 🐳 ————————————————————————————————————————————————————————————————
start: build up ## Build and start the containers

build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
#composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
#	@$(eval c ?=)
#	@$(COMPOSER) $(c)
#
#vendor: ## Install vendors according to the current composer.lock file
#vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
#vendor: composer

composer-install:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) composer install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction

composer:
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) composer $(c)

## —— Yarn 🧙 ——————————————————————————————————————————————————————————————
yarn-add: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) yarn add $(c)

yarn-install:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) yarn install

yarn-dev:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) yarn dev

yarn:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) yarn $(c)

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) $(SYMFONY) $(c)

migration:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) $(SYMFONY) make:migration

migrate:
	@$(DOCKER_COMP) exec -T $(PHP_SERVICE) $(SYMFONY) doctrine:migration:migrate

cc: c=c:c ## Clear the cache
cc: sf
