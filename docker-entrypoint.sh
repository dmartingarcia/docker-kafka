#!/bin/bash
set -e
# Show all environment variables starting with KAFKA
env | grep '^KAFKA'
# Template the server properties file
envsubst < /opt/kafka/config/kraft/server.properties.template > /opt/kafka/config/kraft/server.properties

# Format storage if not already done
bin/kafka-storage.sh format -t "${KAFKA_CLUSTER_ID}" --ignore-formatted -c /opt/kafka/config/kraft/server.properties

# Start Kafka
exec bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties