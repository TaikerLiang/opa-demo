package authz.trino.modules.operations_test

import rego.v1
import data.authz.trino.modules.operations

# Test query operations
test_is_query_operation_allowed if {
	operations.is_query_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "SelectFromColumns"}
	} with data.env.dev.permissions as {
		"alice": {"query:tpch": true}
	}
}

test_is_query_operation_denied if {
	not operations.is_query_operation with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "SelectFromColumns"}
	} with data.env.dev.permissions as {
		"bob": {"read:catalog": true}
	}
}

# Test catalog operations
test_is_catalog_operation_show_catalogs if {
	operations.is_catalog_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "ShowCatalogs"}
	} with data.env.dev.permissions as {
		"alice": {"read:catalog": true}
	}
}

test_is_catalog_operation_show_tables if {
	operations.is_catalog_operation with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "ShowTables"}
	} with data.env.dev.permissions as {
		"bob": {"read:catalog": true}
	}
}

# Test session operations
test_is_session_operation if {
	operations.is_session_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "SetUser"}
	} with data.common.users as {
		"alice": {"department": "eng"}
	}
}

test_is_session_operation_execute_query if {
	operations.is_session_operation with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "ExecuteQuery"}
	} with data.common.users as {
		"bob": {"department": "ops"}
	}
}

# Test system operations
test_is_system_operation if {
	operations.is_system_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "ReadSystemInformation"}
	} with data.common.users as {
		"alice": {"department": "eng"}
	}
}

# Test execute operations
test_is_execute_operation_trino_user if {
	operations.is_execute_operation with input as {
		"context": {"identity": {"user": "trino"}},
		"action": {"operation": "ExecuteQuery"}
	}
}

test_is_execute_operation_regular_user if {
	operations.is_execute_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "ExecuteQuery"}
	}
	
	operations.is_execute_operation with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "ExecuteQuery"}
	}
}

# Test overall operation allowance
test_is_allowed_operation_comprehensive if {
	operations.is_allowed_operation with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "SelectFromColumns"}
	} with data.common.users as {
		"alice": {"department": "eng"}
	} with data.env.dev.permissions as {
		"alice": {"query:tpch": true}
	}
}