# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Docker-based demo environment for Trino and CloudBeaver:

- **Trino**: Distributed SQL query engine running on port 8080
- **CloudBeaver**: Web-based database tool running on port 8978 that connects to Trino

The setup uses Docker Compose to orchestrate two main services with persistent configuration and data volumes.

## Common Commands

### Starting the Environment
```bash
docker-compose up -d
```

### Stopping the Environment
```bash
docker-compose down
```

### View Service Logs
```bash
docker-compose logs trino
docker-compose logs cloudbeaver
```

### Access Points
- Trino Web UI: http://localhost:8080
- CloudBeaver: http://localhost:8978

## Configuration Structure

### Trino Configuration (`trino/`)
- `config.properties`: Main Trino server configuration (coordinator, memory limits)
- `jvm.config`: JVM settings for the Trino process
- `node.properties`: Node-specific settings (environment, ID, data directory)
- `catalog/`: Data source connectors (currently includes TPCH connector)

### CloudBeaver Configuration (`cloudbeaver/`)
- `conf/`: CloudBeaver application configuration
- `workspace/`: User workspace and connection settings

## Data Catalogs

The demo includes a TPCH (Transaction Processing Performance Council) catalog for testing queries against generated benchmark data.

## Volume Mounts

- Trino configurations are mounted from `./trino/etc/` to `/etc/trino/` in container
- Trino data persistence: `./trino/data/` to `/data/trino/`
- CloudBeaver configurations and workspace are persisted via volume mounts