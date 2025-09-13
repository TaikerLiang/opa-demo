# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is an Open Policy Agent (OPA) authorization system for Trino queries. The system provides fine-grained access control for Trino operations through policy-based authorization.

- **OPA Server**: Runs on port 8181 and evaluates authorization policies
- **Policy Structure**: Modular Rego policies organized by functionality
- **Data-Driven**: Uses JSON files for user information and permissions

## Common Commands

### Starting OPA Server
```bash
docker-compose up -d
```

### Stopping OPA Server
```bash
docker-compose down
```

### Running Policy Tests
```bash
opa test opa/tests/unit/authz/trino/
```

### View OPA Logs
```bash
docker-compose logs opa
```

### Policy Formatting
```bash
# Format policies in-place using Docker
docker-compose --profile tools run --rm opa-fmt

# Or using docker directly
docker run --rm -v "$(pwd)/opa/policies:/policies" openpolicyagent/opa:0.69.0 fmt -w /policies
```

### Policy Validation
```bash
# Check formatting without changes
docker run --rm -v "$(pwd)/opa/policies:/policies" openpolicyagent/opa:0.69.0 fmt --diff /policies
```

## Policy Architecture

### Entry Points (`policies/authz/trino/entrypoints/`)
- `allow.rego`: Main authorization decision point that orchestrates all checks

### Modules (`policies/authz/trino/modules/`)
- `user_roles.rego`: User authentication and role management
- `operations.rego`: Operation-specific authorization logic

### Data Structure (`data/`)
- `common/users.json`: User definitions with departments and attributes
- `env/{dev,stage,prod}/permissions.json`: Environment-specific user permissions

## Authorization Flow

1. **Authentication**: Validates user exists in `data.users`
2. **Operation Check**: Maps Trino operations to required permissions
3. **Permission Validation**: Checks user has required permissions in environment data
4. **Decision**: Returns allow/deny based on policy evaluation

## Supported Operations

- **Query Operations**: `SelectFromColumns` (requires `query:tpch`)
- **Catalog Operations**: `ShowCatalogs`, `ShowSchemas`, `ShowTables` (require `read:catalog`)  
- **Session Operations**: `SetUser`, `ExecuteQuery` (allowed for authenticated users)
- **System Operations**: `ReadSystemInformation`, `AccessCatalog` (allowed for authenticated users)