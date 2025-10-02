package authz.trino

import rego.v1

default allow := false

# Debug rule to see what operations are being requested
debug_info := {
	"user": input.context.identity.user,
	"operation": input.action.operation,
	"full_input": input,
}

# Simple demo authorization rules:
# - Alice can do everything
# - Bob is denied everything
# - Everyone else is denied

# Allow Alice to do any operation
allow if {
	input.context.identity.user == "alice"
}

# Allow users from testing department
allow if {
	user := input.context.identity.user
	data.users[user].department == "testing"
}

# Explicitly deny Bob (for demo purposes)
allow if {
	input.context.identity.user == "bob"
	false  # This will always be false, effectively denying Bob
}

# Handle all batch operations - just check if user is allowed
batch_allow := result if {
	input.action.filterResources
	result := [i |
		input.action.filterResources[i]
		allow  # Since allow just checks if user == "alice", no need for complex logic
	]
}

# Handle other batch requests from Trino
batch_allow := result if {
	input.batch
	result := [allow | input.batch[_]]
}