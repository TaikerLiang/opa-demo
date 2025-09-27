package authz.trino.modules.user_roles

import rego.v1

# Check if user is authenticated and exists in the system
is_authenticated_user if {
	input.context.identity.user
	user := input.context.identity.user
	data.common.users[user]
}

# Get current user from input
current_user := input.context.identity.user

# Check if user has specific permission
has_permission(permission) if {
	user := current_user
	data.env.dev.permissions[user][permission]
}

# Check if user is a service account
is_service_account if {
	user := current_user
	data.common.users[user].type == "service_account"
}

# Check if user is in specific department
in_department(dept) if {
	user := current_user
	data.common.users[user].department == dept
}

# Check if user is authorized for Trino operations
is_trino_user if {
	current_user == "trino"
}

# Check if user is a regular authorized user
is_regular_user if {
	current_user in ["alice", "bob", "test"]
}
