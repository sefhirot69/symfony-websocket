.DEFAULT_GOAL := deploy

deploy: build
	@echo "📦 Build done"

build: create_env_file up composer-install

create_env_file:
	@if [ ! -f .env.local ]; then cp app/.env .env.local; fi

# 🐘 Composer
composer-install: ACTION=install

composer-update: ACTION=update $(module)

composer-require: ACTION=require $(module)

composer composer-install composer-update composer-require: create_env_file
	@docker exec symfony-websocket composer $(ACTION) \
			--ignore-platform-reqs \
			--no-ansi
# 🐳 Docker Compose
up:
	@echo "🚀 Deploy!!!"
	@docker-compose up -d
stop:
	@docker-compose stop
restart:
	@docker-compose up -d --build
