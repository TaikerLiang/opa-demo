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

# Handle batch requests from Trino
batch_allow := result if {
	result := [allow | input.batch[_]]
}
