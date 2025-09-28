# Trino Authorization Policies

This directory contains OPA policies for authorizing Trino operations in a simplified structure for demo purposes.

## Structure

### Core Policies
- `allow.rego`: Main authorization entry point with all operation logic
- `user_roles.rego`: User authentication and permission utilities

## Policy Logic

The authorization system uses a simple approach:

1. **User Authentication**: Validates that users exist in the system (`data.users`)
2. **Permission Check**: Verifies user has required permissions (`data.permissions`)
3. **Operation Authorization**: Allows/denies specific Trino operations

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

- `data.users`: User information (see `../data/users.json`)
- `data.permissions`: User permissions (see `../data/permissions.json`)

## Testing

Unit tests are available in `../tests/`:
- `allow_test.rego`: Tests for the main authorization logic
- `user_roles_test.rego`: Tests for user role utilities

Run tests with: `opa test opa/tests/`

## Batch Operations

The system supports Trino's batch authorization for:
- `FilterCatalogs`: Returns allowed catalog indices
- `FilterTables`: Returns allowed table indices