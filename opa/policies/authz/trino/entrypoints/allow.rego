package authz.trino

import data.authz.trino.modules.operations
import data.authz.trino.modules.user_roles
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
	operations.is_allowed_operation
}

# Simple test rule (can be removed in production)
allow if {
	input.user == "alice"
	input.action == "read"
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
