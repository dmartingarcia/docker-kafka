FROM apache/kafka:4.0.0

ENV KAFKA_HOME=/opt/kafka
ENV KAFKA_DATA_DIR=/var/lib/kafka/data
ENV KAFKA_LOG_DIR=/var/log/kafka

WORKDIR ${KAFKA_HOME}


USER root
RUN apk update && \
    apk add --no-cache gettext && \
    adduser -D -H -u 1001 kafka && \
    rm -rf /var/cache/apk/*

# Create data directory with appropriate permissions
RUN mkdir -p ${KAFKA_DATA_DIR} && \
mkdir -p ${KAFKA_LOG_DIR} && \
chown -R kafka:kafka ${KAFKA_LOG_DIR} && \
chown -R kafka:kafka ${KAFKA_DATA_DIR} && \
chown -R kafka:kafka ${KAFKA_HOME}

USER kafka

VOLUME ${KAFKA_DATA_DIR}
VOLUME ${KAFKA_LOG_DIR}

COPY --chown=kafka:kafka config/server.properties.template ${KAFKA_HOME}/config/kraft/server.properties.template
COPY --chown=kafka:kafka docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]