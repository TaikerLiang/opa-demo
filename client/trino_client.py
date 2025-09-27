#!/usr/bin/env python3
"""
Trino client for OPA demo
Executes SQL queries through Trino with user authentication
"""

import trino
from trino.auth import BasicAuthentication
import json
import sys


class TrinoClient:
    def __init__(self, host='localhost', port=8080, user='alice', catalog='tpch', schema='tiny'):
        """
        Initialize Trino client

        Args:
            host: Trino server host
            port: Trino server port
            user: Username for authentication
            catalog: Default catalog
            schema: Default schema
        """
        self.host = host
        self.port = port
        self.user = user
        self.catalog = catalog
        self.schema = schema

        # Create connection
        self.conn = trino.dbapi.connect(
            host=self.host,
            port=self.port,
            user=self.user,
            catalog=self.catalog,
            schema=self.schema,
        )

    def execute_query(self, query):
        """
        Execute SQL query and return results

        Args:
            query: SQL query string

        Returns:
            List of result rows
        """
        try:
            cursor = self.conn.cursor()
            cursor.execute(query)

            # Fetch column names
            columns = [desc[0] for desc in cursor.description] if cursor.description else []

            # Fetch all results
            rows = cursor.fetchall()

            return {
                'columns': columns,
                'rows': rows,
                'row_count': len(rows)
            }
        except Exception as e:
            return {
                'error': str(e),
                'columns': [],
                'rows': [],
                'row_count': 0
            }

    def show_catalogs(self):
        """Show available catalogs"""
        return self.execute_query("SHOW CATALOGS")

    def show_schemas(self, catalog=None):
        """Show available schemas in catalog"""
        cat = catalog or self.catalog
        return self.execute_query(f"SHOW SCHEMAS FROM {cat}")

    def show_tables(self, schema=None, catalog=None):
        """Show available tables in schema"""
        cat = catalog or self.catalog
        sch = schema or self.schema
        return self.execute_query(f"SHOW TABLES FROM {cat}.{sch}")

    def describe_table(self, table, schema=None, catalog=None):
        """Describe table structure"""
        cat = catalog or self.catalog
        sch = schema or self.schema
        return self.execute_query(f"DESCRIBE {cat}.{sch}.{table}")


def main():
    """Main function for CLI usage"""
    if len(sys.argv) < 2:
        print("Usage: python trino_client.py <command> [args...]")
        print("Commands:")
        print("  catalogs                    - Show catalogs")
        print("  schemas [catalog]           - Show schemas")
        print("  tables [schema] [catalog]   - Show tables")
        print("  describe <table>            - Describe table")
        print("  query '<sql>'               - Execute SQL query")
        print("  user <username>             - Set user (default: alice)")
        sys.exit(1)

    command = sys.argv[1]
    user = 'alice'  # Default user

    # Check if user is specified
    if len(sys.argv) > 2 and sys.argv[1] == 'user':
        user = sys.argv[2]
        if len(sys.argv) < 4:
            print(f"User set to: {user}")
            sys.exit(0)
        command = sys.argv[3]
        args = sys.argv[4:]
    else:
        args = sys.argv[2:]

    # Create client
    client = TrinoClient(user=user)

    # Execute command
    if command == 'catalogs':
        result = client.show_catalogs()
    elif command == 'schemas':
        catalog = args[0] if args else None
        result = client.show_schemas(catalog)
    elif command == 'tables':
        schema = args[0] if len(args) > 0 else None
        catalog = args[1] if len(args) > 1 else None
        result = client.show_tables(schema, catalog)
    elif command == 'describe':
        if not args:
            print("Error: table name required")
            sys.exit(1)
        result = client.describe_table(args[0])
    elif command == 'query':
        if not args:
            print("Error: SQL query required")
            sys.exit(1)
        result = client.execute_query(args[0])
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

    # Print results
    if 'error' in result:
        print(f"Error: {result['error']}")
        sys.exit(1)
    else:
        print(f"Columns: {result['columns']}")
        print(f"Rows: {result['row_count']}")
        for row in result['rows']:
            print(row)


if __name__ == '__main__':
    main()