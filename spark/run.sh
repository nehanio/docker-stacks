#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

export SPARK_CONFDIR="${SPARK_HOME}/conf"

# Spark basic cluster
export SPARK_MODE="${SPARK_MODE:-master}"
export SPARK_MASTER_URL="${SPARK_MASTER_URL:-spark://spark-master:7077}"
export SPARK_NO_DAEMONIZE="${SPARK_NO_DAEMONIZE:-true}"
export SPARK_SHUFFLE_ENABLE="${SPARK_SHUFFLE_ENABLE:-false}"

# System Users
export SPARK_DAEMON_USER="spark"
export SPARK_DAEMON_GROUP="spark"

# Spark Config
cp "${SPARK_CONFDIR}/spark-defaults.conf.template" "${SPARK_CONFDIR}/spark-defaults.conf"

LOCAL_DIR="/local"
if [[ ! -d /local ]]; then
  LOCAL_DIR="/tmp"
fi
echo "spark.local.dir $LOCAL_DIR" >> "${SPARK_CONFDIR}/spark-defaults.conf"

if [[ "$SPARK_SHUFFLE_ENABLE" = "yes" ]]; then
    echo "spark.shuffle.service.enabled true" >> "${SPARK_CONFDIR}/spark-defaults.conf"
fi

if [[ "$SPARK_MODE" == "master" ]]; then
    EXEC=$(command -v start-master.sh)
    ARGS=()
else
    EXEC=$(command -v start-slave.sh)
    ARGS=("$SPARK_MASTER_URL")
fi

exec "$EXEC" "${ARGS[@]-}"
