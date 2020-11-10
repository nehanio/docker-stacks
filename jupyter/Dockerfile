ARG BASE_CONTAINER=continuumio/miniconda3:4.8.2
FROM $BASE_CONTAINER

USER root

# Spark dependencies
# Default values can be overridden at build time
# (ARGS are in lower case to distinguish them from ENV)
ARG spark_version="3.0.1"
ARG hadoop_version="3.2"
ARG spark_checksum="E8B47C5B658E0FBC1E57EEA06262649D8418AE2B2765E44DA53AAF50094877D17297CC5F0B9B35DF2CEEF830F19AA31D7E56EAD950BBE7F8830D6874F88CFC3C"
ARG py4j_version="0.10.9"
ARG openjdk_version="11"

ENV APACHE_SPARK_VERSION="${spark_version}" \
    HADOOP_VERSION="${hadoop_version}"

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
    gnupg \
    swig \
    htop  \
    lsof \
    procps \
    npm \
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

# change openblas to mkl
# OpenBLAS has deadlock issue
# https://github.com/xianyi/OpenBLAS/issues/937
# Install Additional Libraries
RUN  conda update -n base conda && \
    conda install --quiet --yes \
    'conda-forge::blas=*=mkl' \
    'conda-forge::fbprophet=0.5*' \
    'conda-forge::pandas-gbq=0.10.0' \
    'conda-forge::google-cloud-bigquery-storage=0.7.0' \
    'conda-forge::pyarrow=0.17.1' \
    'conda-forge::matplotlib=3.2.1' \
    'conda-forge::pyodbc=4.0.30' \
    'numpy=1.18.1' \
    'pandas=0.25.3' \
    'scikit-learn=0.21*' \
    'numexpr=2.6.9' \
    'seaborn=0.9.0' \
    'py-xgboost=0.90' \
    'joblib=0.14.1' \
    'networkx=2.1' \
    'python-louvain=0.11' \
    'dask=2.9.2' \
    'gensim=3.7.3' \
    'scipy=1.2*' \
    'sympy=1.5.1' \
    'cython=0.29.14' \
    'cloudpickle=0.8*' \
    'sqlalchemy=1.3*' \
    'boto3=1.11.9' \
    'mpld3=0.3' \
    'graphviz=2.38.0' \
    'pydotplus=2.0.2' \
    'psycopg2=2.8*' \
    'python-graphviz=0.13.2' \
    'pykalman=0.9.5' \
    'colour' \
    'gspread=3.1.0' \
    'oauth2client=4.1.3' \
    'google-auth=1.6.3' \
    'google-cloud-core=1.3.0' \
    'memory_profiler=0.55.0' \
    'lightgbm=2.3.1' \
    'shap=0.32.1' \
    'imbalanced-learn=0.3.3' \
    'mysql-connector-python' \
    'xlrd' \
    'more-itertools' && \
    conda remove --yes --force qt pyqt && \
    conda clean --all -f -y

RUN pip install --no-cache-dir \
    mojimoji \
    mecab-python3==0.996.3 \
    neologdn==0.4 \
    mlxtend==0.16.0 \
    stldecompose==0.0.5 \
    gspread-dataframe==3.0.3 \
    pytd==0.8.0 \
    wordcloud==1.6.0 \
    PyMySQL==0.9.3 \
    confuse==1.0.0 \
    astropy==3.2.3 \
    missingno==0.4.2 \
    phik==0.9.8 \
    htmlmin==0.1.12 \
    jpholiday==0.1.1 \
    fasttext==0.9.1 \
    pandas-bj==0.1.1 \
    s3fs==0.4.0 \
    tenacity==6.0.0 \
    pg8000==1.13.2 \
    grpcio==1.29.0 \
    grpcio-tools==1.29.0 \
    protobuf3-to-dict==0.1.5 \
    brain-plasma==0.2 \
    && pip install --no-deps \
    awswrangler==0.2.6 \
    statsmodels==0.10.2

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
RUN ln -s "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" spark

# Configure Spark
ENV SPARK_HOME=/usr/local/spark
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-${py4j_version}-src.zip" \
    SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info" \
    PATH=$PATH:$SPARK_HOME/bin

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
