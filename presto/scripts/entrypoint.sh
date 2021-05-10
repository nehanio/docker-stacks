#!/bin/bash

# node
: "${PRESTO_NODE_ID:=$(uuidgen)}"

# config
: "${PRESTO_CONF_COORDINATOR:=true}"
: "${PRESTO_CONF_HTTP_PORT:=8080}"
: "${PRESTO_CONF_DISCOVERY_SERVER_ENABLED:=true}"
: "${PRESTO_CONF_DISCOVERY_URI:=http://localhost:8080}"
: "${PRESTO_CONF_QUERY_MAX_MEMORY:=5GB}"

# node.properties
{
    echo "node.environment=docker"
    echo "node.id=${PRESTO_NODE_ID}"
} > /etc/trino/node.properties

# config.properties
{
    echo "coordinator=${PRESTO_CONF_COORDINATOR}"
    echo "http-server.http.port=${PRESTO_CONF_HTTP_PORT}"
    echo "discovery.uri=${PRESTO_CONF_DISCOVERY_URI}"
    echo "query.max-memory=${PRESTO_CONF_QUERY_MAX_MEMORY}"

    # Only write out coordinator specific configs if this is a coordinator
    if [ $PRESTO_CONF_COORDINATOR == "true" ]; then
        echo "discovery-server.enabled=${PRESTO_CONF_DISCOVERY_SERVER_ENABLED}"
    fi

} > /etc/trino/config.properties

# jvm.config
{
    echo "-server"
    echo "-XX:MaxRAMPercentage=80"
    echo "-XX:-UseBiasedLocking"
    echo "-XX:+UseG1GC"
    echo "-XX:G1HeapRegionSize=32M"
    echo "-XX:+ExplicitGCInvokesConcurrent"
    echo "-XX:+HeapDumpOnOutOfMemoryError"
    echo "-XX:+ExitOnOutOfMemoryError"
    echo "-XX:ReservedCodeCacheSize=256M"
    echo "-XX:PerMethodRecompilationCutoff=10000"
    echo "-XX:PerBytecodeRecompilationCutoff=10000"
    echo "-Djdk.attach.allowAttachSelf=true"
    echo "-Djdk.nio.maxCachedBufferSize=2000000"
} > /etc/trino/jvm.config

# hive
{
    echo "connector.name=hive-hadoop2"
    echo "hive.allow-drop-table=true"
    echo "hive.metastore=glue"
    echo "hive.security=allow-all"
} > "/etc/trino/catalog/glue.properties"

exec "$@"
