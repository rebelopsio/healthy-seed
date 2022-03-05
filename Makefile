MODULE = $(shell go list -m)
VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || echo "0.0.1")
PACKAGES ?= $(shell go list ./... | grep -v /vendor/ 2> /dev/null || "")
# Arguments to pass on each go tool link invocation. In this case, setting the version.
LDFLAGS := -ldflags "-X main.Version=${VERSION}"

.PHONY: default
default: help

# generate help info from comments: thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## help information about make commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: run
run: ## run the API server
	go run ${LDFLAGS} cmd/server/main.go

.PHONY: build
build:  ## build the API server binary
	CGO_ENABLED=0 go build ${LDFLAGS} -a -o server $(MODULE)/cmd/server

.PHONY: build-docker
build-docker: ## build the API server as a docker image
	docker build -f cmd/server/Dockerfile -t server .

.PHONY: version
version: ## display the version of the API server
	@echo $(VERSION)

.PHONY: lint
lint: ## run golint on all Go package
	@golint $(PACKAGES)

.PHONY: fmt
fmt: ## run "go fmt" on all Go packages
	@go fmt $(PACKAGES)

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

.PHONY: sqlc
sqlc: ## generate go code for sql queries
	sqlc generate -f ./config/sqlc.yaml
