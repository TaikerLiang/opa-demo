.PHONY: fmt test up down logs help

# Format OPA policies
fmt:
	docker-compose --profile tools run --rm opa-fmt

# Run OPA tests
test:
	docker run --rm -v "$(PWD)/policies:/policies" -v "$(PWD)/data:/data" openpolicyagent/opa:0.69.0 test /policies/authz/trino /data

# Start OPA server
up:
	docker-compose up -d

# Stop OPA server
down:
	docker-compose down

# View OPA logs
logs:
	docker-compose logs -f opa

# Help
help:
	@echo "Available targets:"
	@echo "  fmt       - Format OPA policies in place"
	@echo "  test      - Run OPA policy tests"
	@echo "  up        - Start OPA server"
	@echo "  down      - Stop OPA server"
	@echo "  logs      - View OPA server logs"
	@echo "  help      - Show this help message"