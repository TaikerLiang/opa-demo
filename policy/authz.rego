package authz

import rego.v1

default allow := false

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
  input.action.operation in ["SetUser", "SetSessionUser", "ResetSessionUser"]
}