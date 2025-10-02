.PHONY: help test test-file fmt up down logs

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

test: ## Run all OPA tests
	docker-compose --profile tools run --rm opa-test

test-file: ## Run specific OPA test file (usage: make test-file FILE=/tests/test_user_permissions.rego)
	@if [ -z "$(FILE)" ]; then \
		echo "Error: FILE is required. Usage: make test-file FILE=/tests/test_user_permissions.rego"; \
		exit 1; \
	fi
	docker-compose --profile tools run --rm opa-test-file test -v $(FILE)

fmt: ## Format OPA policies
	docker-compose --profile tools run --rm opa-test-file fmt -w /policies

up: ## Start OPA server
	docker-compose up -d

down: ## Stop OPA server
	docker-compose down

logs: ## View OPA server logs
	docker-compose logs -f opa
