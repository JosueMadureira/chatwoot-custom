# Variables
APP_NAME := chatwoot
RAILS_ENV ?= development

# Targets
setup:
	gem install bundler
	bundle install
	pnpm install

db_create:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:create

db_migrate:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:migrate

db_seed:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:seed

db_reset:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:reset

db:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:chatwoot_prepare

console:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails console

server:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails server -b 0.0.0.0 -p 3000

burn:
	bundle && pnpm install

run:
	@if [ -f ./.overmind.sock ]; then \
		echo "Overmind is already running. Use 'make force_run' to start a new instance."; \
	else \
		overmind start -f Procfile.dev; \
	fi

force_run:
	@echo "Cleaning up Overmind processes..."
	@lsof -ti:3036 2>/dev/null | xargs kill -9 2>/dev/null || true
	@lsof -ti:3000 2>/dev/null | xargs kill -9 2>/dev/null || true
	@rm -f ./.overmind.sock
	@rm -f tmp/pids/*.pid
	@echo "Cleanup complete"
	overmind start -f Procfile.dev

force_run_tunnel:
	lsof -ti:3000 | xargs kill -9 2>/dev/null || true
	rm -f ./.overmind.sock
	rm -f tmp/pids/*.pid
	overmind start -f Procfile.tunnel

debug:
	overmind connect backend

debug_worker:
	overmind connect worker

docker: 
	docker build -t $(APP_NAME) -f ./docker/Dockerfile .

# Docker Compose: prepara .env, BD e sobe Rails + Sidekiq + Vite (http://localhost:3000)
docker_dev_up:
	@chmod +x docker/scripts/prepare-env-for-docker-dev.sh docker/scripts/up-for-browser-test.sh
	./docker/scripts/up-for-browser-test.sh

# Portainer (UI para Docker): https://docs.portainer.io/start/install/server/docker
portainer_install:
	@chmod +x docker/scripts/install-portainer.sh
	./docker/scripts/install-portainer.sh

# Stack tipo produção (imagem custom + compose em docker/) — ver docker/docker-compose.stack.yml
stack_image:
	./docker/scripts/stack-build-image.sh

stack_up:
	./docker/scripts/stack-up.sh

stack_db_prepare:
	./docker/scripts/stack-db-prepare.sh

.PHONY: setup db_create db_migrate db_seed db_reset db console server burn docker docker_dev_up portainer_install stack_image stack_up stack_db_prepare run force_run force_run_tunnel debug debug_worker
