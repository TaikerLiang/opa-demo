package authz.trino.modules.operations

import rego.v1
import data.authz.trino.modules.user_roles

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
		"ExecuteQuery"
	]
	user_roles.is_authenticated_user
}

# System information operations
is_system_operation if {
	input.action.operation in [
		"ReadSystemInformation", 
		"AccessCatalog", 
		"FilterCatalogs"
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