package authz

import rego.v1

default allow := false

# Debug rule to see what operations are being requested
debug_info := {
  "user": input.context.identity.user,
  "operation": input.action.operation,
  "full_input": input
}

# Allow access if user exists and has appropriate permissions
allow if {
  input.context.identity.user
  user := input.context.identity.user
  data.users[user]
  
  # Check for query permissions
  input.action.operation == "SelectFromColumns"
  data.permissions[user]["query:tpch"]
}

# Allow catalog access
allow if {
  input.context.identity.user
  user := input.context.identity.user
  data.users[user]
  
  # Allow showing catalogs/schemas/tables
  input.action.operation in ["ShowCatalogs", "ShowSchemas", "ShowTables"]
  data.permissions[user]["read:catalog"]
}

# Allow basic connection and session operations
allow if {
  input.context.identity.user
  user := input.context.identity.user
  data.users[user]
  
  # Allow basic session operations
  input.action.operation in ["SetUser", "SetSessionUser", "ResetSessionUser", "ExecuteQuery"]
}

# Allow access to users in data file
allow if {
  input.context.identity.user
  user := input.context.identity.user
  data.users[user]
  
  # Basic permissions for authenticated users
  input.action.operation in ["ReadSystemInformation", "AccessCatalog", "FilterCatalogs"]
}

# Removed temporary rule - now using proper policy enforcement

# Handle batch requests from Trino
batch_allow := result if {
  result := [allow | input.batch[_]]
}