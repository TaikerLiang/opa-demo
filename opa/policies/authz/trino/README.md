# Trino Authorization Policies

This directory contains OPA policies for authorizing Trino operations.

## Structure

### Entrypoints (`entrypoints/`)
- `allow.rego`: Main authorization entry point that orchestrates all authorization decisions

### Modules (`modules/`)
- `user_roles.rego`: User authentication, role checking, and permission utilities
- `operations.rego`: Operation-specific authorization logic for different Trino operations

## Policy Logic

The authorization system follows a modular approach:

1. **User Authentication**: Validates that users exist in the system and extracts user information
2. **Operation Authorization**: Checks if specific Trino operations are allowed based on user permissions
3. **Permission Mapping**: Maps Trino operations to required permissions

## Supported Operations

### Query Operations
- `SelectFromColumns`: Requires `query:tpch` permission

### Catalog Operations  
- `ShowCatalogs`, `ShowSchemas`, `ShowTables`: Require `read:catalog` permission

### Session Operations
- `SetUser`, `SetSessionUser`, `ResetSessionUser`, `ExecuteQuery`: Allowed for all authenticated users

### System Operations
- `ReadSystemInformation`, `AccessCatalog`, `FilterCatalogs`: Allowed for all authenticated users

## Data Dependencies

The policies expect the following data:

- `data.users`: User information (see `../../data/common/users.json`)
- `data.permissions`: User permissions (see `../../data/env/*/permissions.json`)

## Testing

Unit tests are available in `../../tests/unit/authz/trino/`:
- `allow_test.rego`: Tests for the main authorization logic
- `user_roles_test.rego`: Tests for user role utilities  
- `operations_test.rego`: Tests for operation-specific authorization

Run tests with: `opa test opa/tests/unit/authz/trino/`