# README.md

# Kafka Cluster with KRaft

This project sets up a 3-node Kafka cluster using KRaft (without Zookeeper) in Docker.

## About KRaft

This cluster uses Kafka's KRaft (Kafka Raft) consensus mechanism, which replaced ZooKeeper as of Kafka 3.x. KRaft advantages:
- Simplified architecture (no ZooKeeper dependency)
- Better scalability
- Improved stability
- Reduced operational complexity

Each node in this cluster acts as both:
- A controller (handling metadata)
- A broker (handling data)

## Prerequisites

- Docker
- Docker Compose
- Make (optional)

## Project Structure

```
kafka-docker
├── docker
│   ├── kafka
│   │   └── Dockerfile
│   └── config
│       └── kraft.properties
├── docker-compose.yml
├── Makefile
└── README.md
```

## Configuration

The cluster consists of 3 Kafka nodes:
- kafka-1: Accessible at localhost:29092
- kafka-2: Accessible at localhost:29093
- kafka-3: Accessible at localhost:29094

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd kafka-docker
   ```

2. **Build and Start:**
   ```bash
   make build    # Build the images
   make run      # Start the cluster
   ```

## Available Commands

### Cluster Management
```bash
make build           # Build the Kafka Docker image
make run             # Start the Kafka cluster
make down            # Stop the cluster
make restart         # Restart all containers
make status          # Show containers status
make logs            # View logs from all containers
make clean           # Remove containers and networks
make clean-volumes   # Remove Kafka data volumes
make purge           # Complete cleanup (containers + volumes)
```

### Kafka Operations
```bash
# List all topics
make topics

# Create a topic
make create-topic TOPIC=my-topic PARTITIONS=3 REPLICATION=3

# Delete a topic
make delete-topic TOPIC=my-topic

# Show topic details
make describe-topic TOPIC=my-topic

# Produce messages to a topic
make produce TOPIC=my-topic

# Consume messages from a topic
make consume TOPIC=my-topic              # From latest
make consume TOPIC=my-topic FROM_BEGINNING=true  # From beginning

# List consumer groups
make describe-groups

# Show cluster metadata
make cluster-status
```

## Connecting from other services

To connect from other Docker Compose services, add this to your service's docker-compose.yml:

```yaml
networks:
  external:
    name: kafka-docker_kafka-network

services:
  your-service:
    networks:
      - kafka-network
    environment:
      KAFKA_BOOTSTRAP_SERVERS: kafka-1:9092,kafka-2:9092,kafka-3:9092
```

## Data Persistence

Kafka data is persisted using Docker named volumes:
- `kafka-data-1`: Data for node 1
- `kafka-data-2`: Data for node 2
- `kafka-data-3`: Data for node 3

To clean up the volumes:
```bash
make clean-volumes
```

## License

This project is licensed under the MIT License.