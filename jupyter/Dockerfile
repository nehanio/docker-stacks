FROM python:3.7.6-buster

USER root

RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list

ARG openjdk_version="11"
RUN set -ex; \
    # deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
    if [ ! -d /usr/share/man/man1 ]; then \
    mkdir -p /usr/share/man/man1; \
    fi; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    curl \
    file \
    patch \
    git \
    unzip \
    graphviz \
    nkf \
    swig \
    libmecab-dev \
    mecab \
    mecab-ipadic-utf8 \
    fonts-takao \
    unixodbc \
    unixodbc-dev \
    libcap-dev \
    gnupg \
    swig \
    htop  \
    lsof \
    procps \
    npm \
    wget \
    xz-utils \
    "openjdk-${openjdk_version}-jre-headless" \
    ca-certificates-java && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# install ipadic-neologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd && \
    cd .. && \
    rm -rf mecab-ipadic-neologd

# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
ARG spark_version="3.1.1"
ARG hadoop_version="3.2"
ARG spark_checksum="E90B31E58F6D95A42900BA4D288261D71F6C19FA39C1CB71862B792D1B5564941A320227F6AB0E09D946F16B8C1969ED2DEA2A369EC8F9D2D7099189234DE1BE"
ARG py4j_version="0.10.9"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

# Spark installation
WORKDIR /tmp
# Using the preferred mirror to download Spark
# hadolint ignore=SC2046
RUN wget -q $(wget -qO- https://www.apache.org/dyn/closer.lua/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz\?as_json | \
    python -c "import sys, json; content=json.load(sys.stdin); print(content['preferred']+content['path_info'])") && \
    echo "${spark_checksum} *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
    tar xzf "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -C /usr/local --owner root --group root --no-same-owner && \
    rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"

WORKDIR /usr/local
RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark && \
    curl -s -L --url "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.897/aws-java-sdk-bundle-1.11.897.jar" --output /usr/local/spark/jars/aws-java-sdk-bundle-1.11.897.jar && \
    curl -s -L --url "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar" --output /usr/local/spark/jars/hadoop-aws-3.2.0.jar

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-${py4j_version}-src.zip" \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

RUN pip install --upgrade pip \
    pip install --no-cache-dir \
    ## Base packages
    mkl==2021.1.1 \
    six==1.15.0 \
    numpy==1.19.5 \
    pandas==1.2.3 \
    sympy==1.6.2 \
    scipy==1.5.4 \
    scikit-learn==0.21.3 \
    pyarrow==3.0.0 \
    cython==0.29.22 \
    cloudpickle==1.6.0 \
    joblib==0.17.0 \
    numexpr==2.7.1 \
    dask[complete] \
    ## networkx用
    decorator==4.4.2

RUN pip install --no-cache-dir \
    ## Database
    sqlalchemy==1.3.20 \
    pyodbc==4.0.30 \
    psycopg2-binary==2.8.6 \
    pg8000==1.16.6 \
    pytd==1.4.2 \
    mysql-connector-python==8.0.22 \
    PyMySQL==1.0.2 \
    ## AWS
    boto3>=1.11 \
    s3fs==0.4.2 \
    ## Google / GCP
    pandas-gbq==0.14.1 

RUN pip install --no-cache-dir \
    google-cloud-bigquery==2.11.0 \
    google-cloud-bigquery-storage==2.3.0 \
    oauth2client==4.1.3 \
    google-auth==1.23.0 \
    gspread==3.6.0 \
    gspread-dataframe==3.1.1 \
    ## Visualize
    matplotlib==3.3.2 \
    seaborn==0.11.0 \
    graphviz==0.14.2 \
    wordcloud==1.8.0 \
    missingno==0.4.2 \
    mpld3==0.5.1 \
    pydotplus==2.0.2 \
    colour==0.1.5 

RUN pip install --no-cache-dir \
    ## ML
    xgboost==1.2.1 \
    mlxtend==0.16.0 \
    lightgbm==2.3.1 \
    shap==0.39.0 \
    imbalanced-learn==0.5.0 \
    ## NLP
    gensim==3.8.3 \
    mojimoji==0.0.11 \
    mecab-python3==0.996.3 \
    neologdn==0.4 \
    fasttext==0.9.2 \
    ## Other
    brain-plasma==0.3.3 \
    jinja2==2.11.2 \
    more-itertools==8.6.0 \
    grpcio==1.33.2 \
    grpcio-tools==1.33.2 \
    protobuf3-to-dict==0.1.5 \
    phik==0.10.0 \
    astropy==4.1 \
    confuse==1.3.0 \
    xlrd==1.2.0 \
    stldecompose==0.0.5 \
    pykalman==0.9.5 \
    pandas-bj==0.1.1 \
    networkx==2.5 \
    python-louvain==0.14 \
    tenacity==6.2.0 \
    htmlmin==0.1.12 \
    jpholiday==0.1.4 \
    statsmodels==0.10.2

## fbprohet
RUN pip install --no-cache-dir \
    "Cython>=0.22" \
    "cmdstanpy==0.4" \
    "pystan>=2.14,<3" \
    "numpy>=1.10.0" \
    "pandas>=0.23.4" \
    "matplotlib>=2.0.0" \
    "LunarCalendar>=0.0.9" \
    "convertdate>=2.1.2" \
    "holidays>=0.9.5" \
    "setuptools-git>=1.2" \
    "python-dateutil>=2.8.0"
RUN pip install --no-cache-dir fbprophet==0.6

RUN pip install --no-cache-dir --no-deps \
    git+https://github.com/awslabs/aws-data-wrangler.git@0.3.3
