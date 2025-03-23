# Kafka Cluster with KRaFT

This project sets up a secure 3-node Kafka cluster using KRaFT (without Zookeeper) in Docker.

## About KRaFT

This cluster uses Kafka's KRaFT (Kafka Raft) consensus mechanism, which replaced ZooKeeper as of Kafka 3.x. KRaFT advantages:
- Simplified architecture (no ZooKeeper dependency)
- Better scalability
- Improved stability
- Reduced operational complexity

Each node in this cluster acts as both:
- A controller (handling metadata)
- A broker (handling data)

## Architecture

The cluster consists of 3 Kafka nodes:
- kafka1: Accessible at localhost:9092 (broker) and 9093 (controller)
- kafka2: Accessible at localhost:9094 (broker) and 9095 (controller)
- kafka3: Accessible at localhost:9096 (broker) and 9097 (controller)

Each node runs both broker and controller roles using KRaFT consensus protocol.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose v2.0+
- Make (optional)

## Project Structure

```
kafka-docker/
├── config/
│   └── server.properties.template
├── docker/
│   └── Dockerfile
├── docker-compose.yml
├── docker-entrypoint.sh
├── .env
├── Makefile
└── README.md
```

## Configuration

The cluster configuration is managed through environment variables in the `docker-compose.yml` file:

```properties
KAFKA_CLUSTER_ID=KRaft-Cluster-1
KAFKA_VERSION=4.0.0
KAFKA_NUM_PARTITIONS=3
KAFKA_REPLICATION_FACTOR=3
KAFKA_MIN_INSYNC_REPLICAS=2
```

## Security Considerations

> ⚠️ **Important Security Notice**: The current setup doesn't include authentication and encryption.
> For production environments, you should enable:

1. **TLS Encryption**:
   - Generate SSL certificates for each broker
   - Configure SSL listeners
   - Enable SSL for inter-broker communication

2. **Authentication**:
   - Set up SASL authentication (PLAIN, SCRAM, or OAUTHBEARER)
   - Configure ACLs for access control
   - Enable audit logging

Example secure configuration:

```properties
# Security settings to add in server.properties
listeners=SASL_SSL://:9092,CONTROLLER://:9093
security.protocol=SASL_SSL
ssl.keystore.location=/path/to/kafka.keystore.jks
ssl.keystore.password=${SSL_KEYSTORE_PASSWORD}
ssl.key.password=${SSL_KEY_PASSWORD}
sasl.enabled.mechanisms=SCRAM-SHA-512
sasl.mechanism.controller.protocol=SCRAM-SHA-512
```

## Getting Started

1. **Clone and setup:**
   ```bash
   git clone git@github.com:dmartingarcia/docker-kafka.git
   cd kafka-docker
   ```

2. **Start the cluster:**
   ```bash
   make build    # Build images
   make run      # Start cluster
   ```

3. **Verify the setup:**
   ```bash
   make status   # Check container status
   make logs     # View logs
   ```

## Management Commands

### Cluster Operations
```bash
make build           # Build images
make run            # Start cluster
make down           # Stop cluster
make restart        # Restart cluster
make status         # Show status
make logs           # View logs
make clean          # Remove containers
make clean-volumes  # Remove volumes
make purge          # Complete cleanup
```

### Kafka Operations
```bash
make topics                    # List topics
make create-topic TOPIC=test   # Create topic
make describe-topic TOPIC=test # Show topic details
make produce TOPIC=test        # Produce messages
make consume TOPIC=test        # Consume messages
make describe-groups          # List consumer groups
make cluster-status          # Show metadata
```

## Web UI Access

The Kafka UI is available at http://localhost:8080, providing:
- Cluster overview
- Topic management
- Message browser
- Consumer group monitoring

## Data Persistence

Data is persisted in Docker volumes:
- `kafka1_data`: Node 1 data
- `kafka2_data`: Node 2 data
- `kafka3_data`: Node 3 data

## License

MIT License - See LICENSE file for details
