package authz.trino

import data.authz.trino.user_roles
import rego.v1

default allow := false

# Debug rule to see what operations are being requested
debug_info := {
	"user": input.context.identity.user,
	"operation": input.action.operation,
	"full_input": input,
}

# Main authorization entry point
allow if {
	user_roles.is_authenticated_user
	is_allowed_operation
}

# Simple test rule (can be removed in production)
allow if {
	input.user == "alice"
	input.action == "read"
}

# Check if the requested operation is allowed
is_allowed_operation if {
	is_query_operation
}

is_allowed_operation if {
	is_catalog_operation
}

is_allowed_operation if {
	is_session_operation
}

is_allowed_operation if {
	is_system_operation
}

is_allowed_operation if {
	is_execute_operation
}

# Query operations (requires query permissions)
is_query_operation if {
	input.action.operation == "SelectFromColumns"
	user_roles.has_permission("query:tpch")
}

# Catalog browsing operations
is_catalog_operation if {
	input.action.operation in ["ShowCatalogs", "ShowSchemas", "ShowTables"]
	user_roles.has_permission("read:catalog")
}

# Basic session operations (allowed for all authenticated users)
is_session_operation if {
	input.action.operation in [
		"SetUser",
		"SetSessionUser",
		"ResetSessionUser",
		"ExecuteQuery",
	]
	user_roles.is_authenticated_user
}

# System information operations
is_system_operation if {
	input.action.operation in [
		"ReadSystemInformation",
		"AccessCatalog",
		"FilterCatalogs",
	]
	user_roles.is_authenticated_user
}

# Execute query operations with specific user restrictions
is_execute_operation if {
	input.action.operation == "ExecuteQuery"
	user_roles.is_trino_user
}

is_execute_operation if {
	input.action.operation == "ExecuteQuery"
	user_roles.is_regular_user
}

# Handle FilterCatalogs batch operations
batch_allow := result if {
	input.action.operation == "FilterCatalogs"
	result := [i |
		resource := input.action.filterResources[i]
		allow with input as {
			"context": input.context,
			"action": {
				"operation": "AccessCatalog",
				"resource": resource
			}
		}
	]
}

# Handle FilterTables batch operations
batch_allow := result if {
	input.action.operation == "FilterTables"
	result := [i |
		resource := input.action.filterResources[i]
		allow with input as {
			"context": input.context,
			"action": {
				"operation": "SelectFromColumns",
				"resource": resource
			}
		}
	]
}

# Handle other batch requests from Trino
batch_allow := result if {
	input.batch
	result := [allow | input.batch[_]]
}