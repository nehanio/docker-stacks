FROM python:3.7.9-slim

RUN set -ex; \
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
    if [ ! -d /usr/share/man/man1 ]; then \
    	mkdir -p /usr/share/man/man1; \
    fi; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    acl ca-certificates curl gzip unzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g \
    openjdk-11-jre-headless \
    ca-certificates-java \
    libpg-java \
    libmariadb-java && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip3 install pyspark
# for pandasUDF
RUN pip install --upgrade pip \
    pip install --no-cache-dir \
    ## Base packages
    pandas==1.2.3 \
    numpy==1.19.5 \
    scipy==1.5.4 \
    pyarrow==3.0.0 \
    ## NLP
    mojimoji==0.0.11 \
    ## Other
    jpholiday==0.1.4

# HADOOP
ENV HADOOP_VERSION 3.2.2
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin \
    LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"
RUN useradd --system --create-home --home-dir $HADOOP_HOME hadoop \
    && curl -sL --retry 3 \
      "https://ftp.jaist.ac.jp/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
      | gunzip \
      | tar -x -C /usr/ \
    && rm -rf $HADOOP_HOME/share/doc \
    && chown -R hadoop:hadoop $HADOOP_HOME

# SPARK
ENV SPARK_VERSION 3.1.1
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-without-hadoop
ENV SPARK_HOME /usr/spark-${SPARK_VERSION}
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop/*:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH $PATH:${SPARK_HOME}/bin:${SPARK_HOME}/sbin
RUN useradd --system --create-home --home-dir $HADOOP_HOME spark \
    && curl -sL --retry 3 \
      "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
      | gunzip \
      | tar x -C /usr/ \
    && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
    && chown -R spark:spark $SPARK_HOME

RUN curl -s -L --url "https://storage.googleapis.com/spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.19.1.jar" --output /usr/share/java/spark-bigquery-with-dependencies_2.12-0.19.1.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/google/cloud/bigdataoss/gcs-connector/hadoop3-2.2.0/gcs-connector-hadoop3-2.2.0.jar" --output /usr/share/java/gcs-connector-hadoop3-2.2.0.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/google/http-client/google-http-client/1.39.2/google-http-client-1.39.2.jar" --output /usr/share/java/google-http-client-1.39.2.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/google/oauth-client/google-oauth-client/1.31.5/google-oauth-client-1.31.5.jar" --output /usr/share/java/google-oauth-client-1.31.5.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/google/api-client/google-api-client/1.31.4/google-api-client-1.31.4.jar" --output /usr/share/java/google-api-client-1.31.4.jar

COPY ./spark/run.sh  /run.sh
RUN chmod +x /run.sh

USER spark
WORKDIR $SPARK_HOME

CMD ["/run.sh"]
