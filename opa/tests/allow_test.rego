package authz.trino_test

import data.authz.trino

import rego.v1

# Test basic authentication and authorization
test_allow_authenticated_user_query if {
	trino.allow with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "SelectFromColumns"}
	} with data.users as {
		"alice": {"department": "eng"}
	} with data.permissions as {
		"alice": {"query:tpch": true}
	}
}

test_deny_unauthenticated_user if {
	not trino.allow with input as {
		"context": {"identity": {"user": "unknown"}},
		"action": {"operation": "SelectFromColumns"}
	} with data.users as {
		"alice": {"department": "eng"}
	}
}

test_allow_catalog_operations if {
	trino.allow with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "ShowCatalogs"}
	} with data.users as {
		"bob": {"department": "ops"}
	} with data.permissions as {
		"bob": {"read:catalog": true}
	}
}

test_simple_alice_rule if {
	trino.allow with input as {
		"user": "alice",
		"action": "read"
	}
}

test_batch_requests if {
	result := trino.batch_allow with input as {
		"batch": [
			{"context": {"identity": {"user": "alice"}}, "action": {"operation": "ShowCatalogs"}},
			{"context": {"identity": {"user": "bob"}}, "action": {"operation": "ShowTables"}}
		]
	} with data.users as {
		"alice": {"department": "eng"},
		"bob": {"department": "ops"}
	} with data.permissions as {
		"alice": {"read:catalog": true},
		"bob": {"read:catalog": true}
	}
	
	count(result) == 2
}