# Trino Client

Python client for executing SQL queries through Trino with OPA authorization.

## Setup

1. Install dependencies with Poetry:
```bash
poetry install
```

2. Activate virtual environment:
```bash
poetry shell
```

## Usage

### Basic Commands

```bash
# Show catalogs
python trino_client.py catalogs

# Show schemas
python trino_client.py schemas [catalog]

# Show tables
python trino_client.py tables [schema] [catalog]

# Describe table structure
python trino_client.py describe <table_name>

# Execute SQL query
python trino_client.py query "SELECT * FROM nation LIMIT 5"
```

### Using Different Users

```bash
# Set user and execute command
python trino_client.py user alice catalogs
python trino_client.py user bob query "SELECT * FROM nation LIMIT 3"
```

## Examples

```bash
# Alice queries (has query:tpch permission)
python trino_client.py user alice query "SELECT * FROM nation LIMIT 5"

# Bob queries (has query:tpch permission)
python trino_client.py user bob query "SELECT name FROM nation LIMIT 3"

# Show catalogs (requires read:catalog permission)
python trino_client.py user alice catalogs
```

## Notes

- Default user is `alice`
- Default catalog is `tpch`
- Default schema is `tiny`
- Trino server should be running on localhost:8080
- OPA server should be running on localhost:8181 for authorization