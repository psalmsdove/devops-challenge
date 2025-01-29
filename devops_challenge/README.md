# DevOps Study Case

## Project Description
This project aims to set up a local development environment using Docker Compose, including PostgreSQL, Redis, Prometheus, and Grafana services. Additionally, shell scripts are provided to test whether the services are running correctly.

## Requirements
- Docker
- Docker Compose

## Installation Steps

### 1. Installing Dependencies
Run the `install_dependencies.sh` script to install the necessary dependencies:
```bash
./scripts/install_dependencies.sh
```
### 2. Starting Services
```bash
docker compose up -d
```

### 3. Testing PSQL and Redis
While you are in the project direction, you can run the following scripts one by one to test if PSQL and Redis services are installed and running:
```bash
./scripts/test_postgres.sh
./scripts/test_redis.sh
```
### 4. Accessing Monitoring Tools 
You can access to Prometheus and Grafana through your browser: 

Prometheus: http://localhost:9090

Grafana: http://localhost:3000

There are 3 different dashboards in Grafana. You can see different and basic metrics on each dashboard. 

For "Docker and system monitoring with cAdvisor" dashboard you need to change time range to at least 6 hour, or 15 minutes for better results.

If you go to "Explore > Metrics" in Grafana panel, you can see a lot more metrics.

## File Structure
```bash
devops-challenge/
├── docker-compose.yml
├── scripts/
│   ├── install_dependencies.sh
│   ├── test_postgres.sh
│   └── test_redis.sh
├── monitoring/
│   ├── prometheus.yml
├── database/
│   └── init.sql
├── README.md
└── .gitignore
 ```

## Docker Compose Configuration

I used special network called "devops-monitoring". Each service in the Docker Compose file uses a network to ensure seamless communication between containers. This setup allows services to resolve each other by name and provides isolation and security within the defined network.

```bash

networks: 
   devops-monitoring:

services:
  postgres-db:
    image: postgres:latest
    container_name: postgres-db
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
      POSTGRES_DB: devops_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks: 
      - devops-monitoring

  redis-cache:
    image: redis:latest
    container_name: redis-cache
    ports:
      - "6379:6379"
    networks: 
      - devops-monitoring

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    networks: 
      - devops-monitoring

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - "3000:3000"
    networks: 
      - devops-monitoring

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks: 
      - devops-monitoring

volumes:
  postgres_data:
  grafana_data:
 ```

## Prometheus Configuration

```bash
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "docker"
    static_configs:
      - targets: ["host.docker.internal:9090"]
  - job_name: "postgres"
    static_configs:
      - targets: ["postgres-db:5432"]
  - job_name: "redis"
    static_configs:
      - targets: ["redis-cache:6379"] 
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

```
