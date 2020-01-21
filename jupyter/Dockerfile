ARG BASE_CONTAINER=python:3.8.1-slim-buster
FROM $BASE_CONTAINER

ENV MKL_ROOT_DIR=/opt/intel/mkl
ENV LD_LIBRARY_PATH=$MKL_ROOT_DIR/lib/intel64:/opt/intel/lib/intel64_lin:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=$MKL_ROOT_DIR/lib/intel64:$LIBRARY_PATH
ENV PKG_CONFIG_PATH=$MKL_ROOT_DIR/bin/pkgconfig:$PKG_CONFIG_PATH

USER root

COPY .numpy-site.cfg /root/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
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
    libpng-dev \
    libfreetype6-dev \
    pkg-config \
    libpq-dev \
    python3-dev \
    libsnappy-dev \
    wget \
    gnupg \
    libopenblas-dev \
    liblapack-dev \
    cython \
    gfortran \
    && rm -rf /var/lib/apt/lists/*


# change openblas to mkl
# OpenBLAS has deadlock issue
# https://github.com/xianyi/OpenBLAS/issues/937
# Install Additional Libraries
RUN cd /tmp && \
    wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
    rm GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

RUN wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list && \
    apt-get update && \
    apt-get install -y intel-mkl-64bit-2020.0-088 && \
    rm -rf /var/lib/apt/lists/*

RUN cd / && \
    pip install --force --no-binary :all: numpy==1.17.4 scipy==1.4.1

# install ipadic-neologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd && \
    cd .. && \
    rm -rf mecab-ipadic-neologd


COPY ./requirements.txt /tmp/requirements.txt
#RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ENV XDG_CACHE_HOME ./.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions .
