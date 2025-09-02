# GEMINI.md

This file provides guidance when working with code in this repository.

## Architecture Overview

This is a Docker-based demo environment for Trino and CloudBeaver:

- **Trino**: A distributed SQL query engine. The service is configured to run on port 8080.
- **CloudBeaver**: A web-based database tool that can connect to Trino. The service is configured to run on port 8978.

The setup uses Docker Compose to orchestrate the two services. The `docker-compose.yml` file defines the `trino` and `cloudbeaver` services and their configurations.

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

### Trino Configuration

The Trino configuration is located in the `trino/etc/` directory. The `docker-compose.yml` file mounts this directory to `/etc/trino` in the Trino container.

- `config.properties`: Main Trino server configuration.
- `jvm.config`: JVM settings for the Trino process.
- `node.properties`: Node-specific settings.
- `catalog/`: Contains connector configurations.
    - `tpch.properties`: Configures the TPCH connector, which provides sample data for testing.

**Note:** The configuration files in the `trino/` directory are duplicates of the files in `trino/etc/` and are not used by the Docker container.

### CloudBeaver Configuration

The CloudBeaver configuration and workspace data are managed by the `dbeaver/cloudbeaver` Docker image. The `docker-compose.yml` file defines a volume for `cloudbeaver_data` to persist this data.

## Data Catalogs

The demo includes the TPCH (Transaction Processing Performance Council) catalog for testing queries against generated benchmark data. This is configured in the `trino/etc/catalog/tpch.properties` file.
