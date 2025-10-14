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

# Allow Bob (with row-level filtering applied)
allow if {
	input.context.identity.user == "bob"
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

# Default: no filter (allow all rows)
default row_filters := []

# User-specific filters (higher priority - checked first)
# Match Trino's actual input structure: input.context.identity.user
row_filters := result if {
    input.context.identity.user == "bob"
    result := [{"expression": "nationkey < 5"}]
}

# Table-specific filters (only apply if user-specific filters don't match)
# Match Trino's structure: input.action.resource.table
row_filters := result if {
    input.context.identity.user != "bob"  # Only apply if bob's rule didn't match
    input.action.resource.table.catalogName == "tpch"
    input.action.resource.table.schemaName == "sf1"
    input.action.resource.table.tableName == "nation"

    result := [{"expression": "regionkey = 1"}]   # Only see region 1
}
