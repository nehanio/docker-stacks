FROM python:3.7.9-slim

RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list

RUN set -ex; \
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
    if [ ! -d /usr/share/man/man1 ]; then \
    	mkdir -p /usr/share/man/man1; \
    fi; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    acl ca-certificates curl gzip unzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g \
    nvidia-openjdk-8-jre \
    ca-certificates-java \
    libpg-java \
    libmariadb-java \
    gnupg2 && \
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


# CUDA 10.1
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-1 \
    && ln -s cuda-10.1 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1 brand=tesla,driver>=396,driver<397 brand=tesla,driver>=410,driver<411 brand=tesla,driver>=418,driver<419"


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
    curl -s -L --url "https://repo1.maven.org/maven2/com/google/cloud/bigdataoss/gcs-connector/hadoop3-2.2.0/gcs-connector-hadoop3-2.2.0-shaded.jar" --output /usr/share/java/gcs-connector-hadoop3-2.2.0-shaded.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/nvidia/rapids-4-spark_2.12/0.5.0/rapids-4-spark_2.12-0.5.0.jar" --output /usr/share/java/rapids-4-spark_2.12-0.5.0.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/ai/rapids/cudf/0.19.2/cudf-0.19.2-cuda10-1.jar" --output /usr/share/java/cudf-0.19.2-cuda10-1.jar && \
    curl -s -L --url "https://github.com/apache/spark/blob/master/examples/src/main/scripts/getGpusResources.sh" --output /usr/share/java/getGpusResources.sh


COPY ./spark/run.sh  /run.sh
RUN chmod +x /run.sh

USER spark
WORKDIR $SPARK_HOME

CMD ["/run.sh"]
