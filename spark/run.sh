#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Spark basic cluster
export SPARK_MODE="${SPARK_MODE:-master}"
export SPARK_MASTER_URL="${SPARK_MASTER_URL:-spark://spark-master:7077}"
export SPARK_NO_DAEMONIZE="${SPARK_NO_DAEMONIZE:-true}"
# RPC Authentication and Encryption
export SPARK_RPC_AUTHENTICATION_ENABLED="${SPARK_RPC_AUTHENTICATION_ENABLED:-no}"
export SPARK_RPC_AUTHENTICATION_SECRET="${SPARK_RPC_AUTHENTICATION_SECRET:-}"
export SPARK_RPC_ENCRYPTION_ENABLED="${SPARK_RPC_ENCRYPTION_ENABLED:-no}"
# Local Storage Encryption
export SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED="${SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED:-no}"
# SSL
export SPARK_SSL_ENABLED="${SPARK_SSL_ENABLED:-no}"
export SPARK_SSL_KEY_PASSWORD="${SPARK_SSL_KEY_PASSWORD:-}"
export SPARK_SSL_KEYSTORE_PASSWORD="${SPARK_SSL_KEYSTORE_PASSWORD:-}"
export SPARK_SSL_TRUSTSTORE_PASSWORD="${SPARK_SSL_TRUSTSTORE_PASSWORD:-}"
export SPARK_SSL_NEED_CLIENT_AUTH="${SPARK_SSL_NEED_CLIENT_AUTH:-yes}"
export SPARK_SSL_PROTOCOL="${SPARK_SSL_PROTOCOL:-TLSv1.2}"
# Monitoring
export SPARK_METRICS_ENABLED="${SPARK_METRICS_ENABLED:-false}"
# System Users
export SPARK_DAEMON_USER="spark"
export SPARK_DAEMON_GROUP="spark"

if [ "$SPARK_MODE" == "master" ]; then
    EXEC=$(command -v start-master.sh)
    ARGS=()
else
    EXEC=$(command -v start-slave.sh)
    ARGS=("$SPARK_MASTER_URL")
fi

exec "$EXEC" "${ARGS[@]-}"
