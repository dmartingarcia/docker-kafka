FROM eclipse-temurin:17-jre-jammy

ENV KAFKA_VERSION=3.6.1
ENV SCALA_VERSION=2.13
ENV KAFKA_HOME=/opt/kafka
ENV KAFKA_DATA_DIR=/var/lib/kafka/data

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    tar xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} && \
    rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

WORKDIR ${KAFKA_HOME}

# Create data directory with appropriate permissions
RUN mkdir -p ${KAFKA_DATA_DIR} && \
    chown -R 1000:1000 ${KAFKA_DATA_DIR}

VOLUME ${KAFKA_DATA_DIR}

COPY start-kafka.sh /start-kafka.sh
RUN chmod +x /start-kafka.sh

CMD ["/start-kafka.sh"]