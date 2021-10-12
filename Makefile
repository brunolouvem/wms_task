# Setup database for development env
.PHONY: setup_db
setup_db:
	mix ecto.create && \
	mix ecto.migrate

# UP all containers
.PHONY: up
up:
	id && \
	UID=$${UID} GID=$${GID} docker-compose up -d

# Down all containers
.PHONY: down
down:
	docker-compose down
	docker volume rm $$(docker volume ls -q | grep wms_task)

# Run application CI verifications
.PHONY: ci-checks
cc:
	@echo "Executing CI Checkings"
	mix compile --warnings-as-errors
	MIX_ENV=test mix test
	mix format
	mix format --check-formatted
	mix credo --strict
	@echo "Ready to CI!!!🚀🚀🚀"

# Run application suite test in container
.PHONY: test
test:
	docker exec -it wms_tasks bash -c "MIX_ENV=test mix test --cover"

# Run application in development mode
.PHONY: run_dev
run_dev: setup_db
	mix phx.server

# Start container bash
.PHONY: dev_shell
dev_shell:
	docker exec -it wms_tasks bash

# Build application as production mode
.PHONY: build_prod
build_prod:
	docker build . -t wms_tasks:latest 

# Run application container in production mode, this make task depends of postgres container to work, 
# if you have another database, you can change DATABASE_URL and remove --link argument of command below.
.PHONY: run_prod
run_prod:
	docker run -it --rm --name wms_tasks_prd --network wms_task_new_default --link wms_task_new_postgres_1:postgres -p 4000:4000 \
	-e DATABASE_URL='postgres://postgres:postgres@postgres:5432/wms_task_dev' \
	-e PULPO_USER='felipe_user1' \
	-e PULPO_URL='https://show.pulpo.co/api/v1' \
	-e SECRET_KEY_BASE='KN6UOFbqvVtYnFrGPVEVPnL3NytLbg' wms_tasks:latest