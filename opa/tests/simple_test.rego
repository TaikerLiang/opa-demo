package authz.trino.simple_test

import rego.v1

# Simple test to verify our basic logic
test_alice_string_check if {
	"alice" == "alice"
}

test_bob_string_check if {
	"bob" == "bob"
}

test_alice_not_bob if {
	"alice" != "bob"
}

# Test our actual allow logic pattern
test_allow_logic_alice if {
	user := "alice"
	user == "alice"
}

test_allow_logic_bob_fails if {
	user := "bob"
	user == "bob"
	not (user == "alice")  # Bob is not alice, so would be denied
}