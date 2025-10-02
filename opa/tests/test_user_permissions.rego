package authz.trino.test_user_permissions

import rego.v1
import data.authz.trino.allow

# Test Alice is allowed
test_alice_allowed if {
	allow with input as {
		"context": {"identity": {"user": "alice"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"alice": {"department": "eng"}}
}

# Test Bob is denied
test_bob_denied if {
	not allow with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"bob": {"department": "ops"}}
}

# Test unknown user is denied
test_unknown_user_denied if {
	not allow with input as {
		"context": {"identity": {"user": "charlie"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"alice": {"department": "eng"}}
}
