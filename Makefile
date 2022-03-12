MODULE = $(shell go list -m)
VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || echo "0.0.1")
PACKAGES := $(shell go list ./... | grep -v /vendor/ )
# Arguments to pass on each go tool link invocation. In this case, setting the version.
LDFLAGS := -ldflags "-X main.Version=${VERSION}"
CONFIG_FILE ?= ./config/local.yml
APP_DSN ?= $(shell sed -n 's/^dsn:[[:space:]]*"\(.*\)"/\1/p' $(CONFIG_FILE))
MIGRATE := docker run -v $(shell pwd)/migration:/migration --network host migrate/migrate:v4.10.0 -path=/migration/ -database "$(APP_DSN)"

.PHONY: default
default: help

.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help screen.
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: run
run: ## run the API server
	go run ${LDFLAGS} cmd/server/main.go

.PHONY: version
version: ## display the version of the API server
	@echo $(VERSION)

##@ Test
.PHONY: test
test: ## run unit tests
	@echo "mode: count" > coverage-all.out
	@$(foreach pkg,$(PACKAGES), \
		go test -p=1 -cover -covermode=count -coverprofile=coverage.out ${pkg}; \
		tail -n +2 coverage.out >> coverage-all.out;)

.PHONY: test-cover
test-cover: test ## run unit tests and show test coverage information
	go tool cover -html=coverage-all.out

##@ Build
.PHONY: build
build:  ## build the API server binary
	CGO_ENABLED=0 go build ${LDFLAGS} -a -o server $(MODULE)/cmd/server

.PHONY: build-docker
build-docker: ## build the API server as a docker image
	docker build -f cmd/server/Dockerfile -t server .

.PHONY: lint
lint: ## run golint on all Go package
	@golint $(PACKAGES)

.PHONY: fmt
fmt: ## run "go fmt" on all Go packages
	@go fmt $(PACKAGES)

.PHONY: lint
lint: ## run golint on all Go package
	@golint $(PACKAGES)

##@ Database
.PHONY: postgres
postgres: ## run a postgres container in docker
	docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

.PHONY: createdb
createdb: # create the db on the postgres docker container
	docker exec -it postgres14 createdb --username=root --owner=root healthy_seed

.PHONY: dropdb
dropdb: ## drop the db on the postgres docker container
	docker exec -it postgres14 dropdb healthy_seed

.PHONY: migrateup
migrateup: ## run the db migration up on the postgres docker container
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/healthy_seed?sslmode=disable" -verbose up

.PHONY: migratedown
migratedown: ## run the db migration down on the postgres docker container
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/healthy_seed?sslmode=disable" -verbose down

# Build pipeline step
.PHONY: migrate
migrate: ## run all new database migrations
	@echo "Running all new database migrations..."
	@$(MIGRATE) up

##@ Code Creation
.PHONY: sqlc
sqlc: ## generate go code for sql queries
	sqlc generate -f ./config/sqlc.yaml
