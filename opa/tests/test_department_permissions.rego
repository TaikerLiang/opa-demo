package authz.trino.test_department_permissions

import rego.v1
import data.authz.trino.allow

# Test user from testing department is allowed
test_testing_department_allowed if {
	allow with input as {
		"context": {"identity": {"user": "test"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"test": {"department": "testing"}}
}

# Test another user from testing department is allowed
test_testing_department_multiple_users if {
	allow with input as {
		"context": {"identity": {"user": "tester2"}},
		"action": {"operation": "ShowCatalogs"},
	}
		with data.users as {"tester2": {"department": "testing"}}
}

# Test user from non-testing department is denied (unless they're alice)
test_non_testing_department_denied if {
	not allow with input as {
		"context": {"identity": {"user": "bob"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"bob": {"department": "ops"}}
}

# Test user from eng department is denied (unless they're alice)
test_eng_department_denied if {
	not allow with input as {
		"context": {"identity": {"user": "carol"}},
		"action": {"operation": "SelectFromColumns"},
	}
		with data.users as {"carol": {"department": "eng"}}
}
