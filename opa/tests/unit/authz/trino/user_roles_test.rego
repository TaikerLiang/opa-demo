package authz.trino.modules.user_roles_test

import rego.v1
import data.authz.trino.modules.user_roles

# Test authenticated user detection
test_is_authenticated_user_valid if {
	user_roles.is_authenticated_user with input as {
		"context": {"identity": {"user": "alice"}}
	} with data.common.users as {
		"alice": {"department": "eng"}
	}
}

test_is_authenticated_user_invalid if {
	not user_roles.is_authenticated_user with input as {
		"context": {"identity": {"user": "unknown"}}
	} with data.common.users as {
		"alice": {"department": "eng"}
	}
}

# Test current user extraction
test_current_user if {
	user_roles.current_user == "alice" with input as {
		"context": {"identity": {"user": "alice"}}
	}
}

# Test service account detection
test_is_service_account if {
	user_roles.is_service_account with input as {
		"context": {"identity": {"user": "trino"}}
	} with data.common.users as {
		"trino": {"type": "service_account", "department": "system"}
	}
}

test_is_not_service_account if {
	not user_roles.is_service_account with input as {
		"context": {"identity": {"user": "alice"}}
	} with data.common.users as {
		"alice": {"department": "eng"}
	}
}

# Test user type checks
test_is_trino_user if {
	user_roles.is_trino_user with input as {
		"context": {"identity": {"user": "trino"}}
	}
}

test_is_regular_user if {
	user_roles.is_regular_user with input as {
		"context": {"identity": {"user": "alice"}}
	}
	
	user_roles.is_regular_user with input as {
		"context": {"identity": {"user": "bob"}}
	}
}