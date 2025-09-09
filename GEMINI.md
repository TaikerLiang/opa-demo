# GEMINI.md

This file provides guidance when working with code in this repository.

## Architecture Overview

This is a Docker-based demo environment for Trino, CloudBeaver, and Open Policy Agent (OPA):

- **Trino**: A distributed SQL query engine. The service is configured to run on port 8080.
- **CloudBeaver**: A web-based database tool that can connect to Trino. The service is configured to run on port 8978.
- **OPA**: A policy engine for authorization. The service is configured to run on port 8181.

The setup uses Docker Compose to orchestrate the three services. The `docker-compose.yml` file defines the `trino`, `cloudbeaver`, and `opa` services and their configurations.

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
docker-compose logs opa
```

### Access Points
- Trino Web UI: http://localhost:8080
- CloudBeaver: http://localhost:8978
- OPA API: http://localhost:8181

## Configuration Structure

### Trino Configuration

The Trino configuration is located in the `trino/etc/` directory. The `docker-compose.yml` file mounts this directory to `/etc/trino` in the Trino container.

- `config.properties`: Main Trino server configuration.
- `jvm.config`: JVM settings for the Trino process.
- `node.properties`: Node-specific settings.
- `catalog/`: Contains connector configurations.
    - `tpch.properties`: Configures the TPCH connector, which provides sample data for testing (read-only).
    - `memory.properties`: Configures the Memory connector, which allows creating tables in memory (writable).

### CloudBeaver Configuration

The CloudBeaver configuration and workspace data are managed by the `dbeaver/cloudbeaver` Docker image. The `docker-compose.yml` file defines a volume for `cloudbeaver_data` to persist this data.

### OPA Configuration

The OPA configuration is managed through the `docker-compose.yml` file and the following mounted files and directories:

- `config.yaml`: The main configuration file for OPA. It defines the authorization service and decision logging.
- `policy/`: This directory contains the Rego policy files that define your authorization rules.
- `data/`: This directory can be used to provide data to your policies.

## OPA Integration

The `opa` service is configured to act as an authorization server. The `config.yaml` file specifies that the authorization decision can be found at the `data.authz` resource. You can query this endpoint to get authorization decisions based on the policies you define in the `policy/` directory.