ARG FROM_IMAGE=nvidia/cuda
ARG CUDA_VERSION=10.2
ARG CUDA_SHORT_VERSION=${CUDA_VERSION}
ARG LINUX_VERSION=ubuntu18.04
FROM ${FROM_IMAGE}:${CUDA_VERSION}-devel-${LINUX_VERSION}

# Define arguments
ARG CUDA_SHORT_VERSION
ARG CC_VERSION=7
ARG CXX_VERSION=7
ARG PYTHON_VERSION=3.7
ARG CFFI_VERSION=1.11.5
ARG CUPY_VERSION=7.0
ARG CYTHON_VERSION=0.29
ARG CMAKE_VERSION=3.14.5
ARG NUMBA_VERSION=0.48
ARG NUMPY_VERSION=1.17.3
ARG PANDAS_VERSION=0.25
ARG PYARROW_VERSION=0.15.0
ARG ARROW_CPP_VERSION=0.15.0
ARG DOUBLE_CONVERSION_VERSION=3.1.5
ARG RAPIDJSON_VERSION=1.1.0
ARG FLATBUFFERS_VERSION=1.10.0
ARG BOOST_CPP_VERSION=1.70.0
ARG FASTAVRO_VERSION=0.22.3
ARG DLPACK_VERSION=0.2
ARG SKLEARN_VERSION=0.21.3
ARG SCIPY_VERSION=1.3.0
ARG LIBGCC_NG_VERSION=7.3.0
ARG LIBGFORTRAN_NG_VERSION=7.3.0
ARG LIBSTDCXX_NG_VERSION=7.3.0
ARG CLANG_VERSION=8.0.1
ARG LIBRDKAFKA_VERSION=1.2.2
ARG OPENBLAS_VERSION=2.14
ARG TINI_VERSION=v0.18.0
ARG HASH_JOIN=ON
ARG CONDA_VERSION=4.7.12
ARG CONDA_BUILD_VERSION=3.18.11
ARG CONDA_VERIFY_VERSION=3.1.1
ARG MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh

# Set environment
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib
ENV CUDA_HOME=/usr/local/cuda
ENV CC=/usr/bin/gcc-${CC_VERSION}
ENV CXX=/usr/bin/g++-${CXX_VERSION}
ENV CUDAHOSTCXX=/usr/bin/g++-${CXX_VERSION}
ENV PATH=${PATH}:/conda/bin
ENV DEBIAN_FRONTEND=noninteractive

# Update and add pkgs
RUN apt-get update -y --fix-missing && \
      apt-get upgrade -y && \
      apt-get -qq install apt-utils -y --no-install-recommends && \
      apt-get install -y \
        awscli \
        curl \
        git \
        jq \
        screen \
        libnuma1 \
        libnuma-dev \
        tzdata \
        wget \
        vim \
        zlib1g-dev \
      && rm -rf /var/lib/apt/lists/*

# Install conda
RUN curl ${MINICONDA_URL} -k -o /miniconda.sh \
      && sh /miniconda.sh -b -p /conda \
      && rm -f /miniconda.sh \
      && echo "conda ${CONDA_VERSION}" >> /conda/conda-meta/pinned

# Add a condarc
COPY ./.condarc /conda/.condarc

# Add utlities to base env
RUN conda install -y \
      anaconda-client \
      codecov \
      conda=${CONDA_VERSION} \
      conda-build=${CONDA_BUILD_VERSION} \
      conda-verify=${CONDA_VERIFY_VERSION} \
      ripgrep

# Create gdf conda env
RUN conda create --no-default-packages -n nehan \
      python=${PYTHON_VERSION} \
      arrow-cpp=${ARROW_CPP_VERSION} \
      cffi=${CFFI_VERSION} \
      cmake=${CMAKE_VERSION} \
      cmake_setuptools \
      conda=${CONDA_VERSION} \
      conda-build=${CONDA_BUILD_VERSION} \
      conda-verify=${CONDA_VERIFY_VERSION} \
      cudatoolkit=${CUDA_SHORT_VERSION} \
      cupy=${CUPY_VERSION} \
      cython=${CYTHON_VERSION} \
      flake8 \
      black \
      isort \
      make \
      numba">=${NUMBA_VERSION}" \
      numpy=${NUMPY_VERSION} \
      pandas=${PANDAS_VERSION} \
      pyarrow=${PYARROW_VERSION} \
      double-conversion=${DOUBLE_CONVERSION_VERSION} \
      rapidjson=${RAPIDJSON_VERSION} \
      flatbuffers=${FLATBUFFERS_VERSION} \
      boost-cpp=${BOOST_CPP_VERSION} \
      fastavro=${FASTAVRO_VERSION} \
      dlpack=${DLPACK_VERSION} \
      pytest \
      pytest-cov \
      scikit-learn=${SKLEARN_VERSION} \
      scipy=${SCIPY_VERSION} \
      # conda-forge::blas=${OPENBLAS_VERSION}=openblas \
      'conda-forge::blas=*=mkl' \
      libgcc-ng=${LIBGCC_NG_VERSION} \
      libgfortran-ng=${LIBGFORTRAN_NG_VERSION} \
      libstdcxx-ng=${LIBSTDCXX_NG_VERSION} \
      conda-forge::clang=${CLANG_VERSION} \
      conda-forge::clang-tools=${CLANG_VERSION} \
      librdkafka=${LIBRDKAFKA_VERSION} \
      twine \
    && conda install -y -n nehan -c rapidsai -c nvidia -c numba -c conda-forge -c defaults cudf=0.13 python=3.7 cudatoolkit=10.2 \
    && conda install -y -n nehan -c rapidsai -c nvidia -c numba -c conda-forge -c defaults cuml=0.13 python=3.7 cudatoolkit=10.2 \
    && conda clean -afy \
    && chmod -R ugo+w /conda

# enables source activate
SHELL ["/bin/bash", "-c"]

RUN source activate nehan \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    file \
    patch \
    git \
    unzip \
    nkf \
    swig \
    libmecab-dev \
    mecab \
    mecab-ipadic-utf8 \
    fonts-takao \
    graphviz \
    && apt-get autoremove

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
RUN source activate nehan \
    && conda update -n base conda \
    && conda install --quiet --yes -n nehan \
    # 'conda-forge::blas=*=mkl' \
    'conda-forge::fbprophet=0.5*' \
    'conda-forge::pandas-gbq=0.10.0' \
    'conda-forge::google-cloud-bigquery-storage=0.7.0' \
    'numpy=1.18.1' \
    'pandas=0.25.3' \
    'scikit-learn=0.21*' \
    'numexpr=2.6.9' \
    'seaborn=0.9.0' \
    'py-xgboost=0.90' \
    'joblib=0.14.1' \
    # 'awswrangler=0.2.6' \
    'networkx=2.4' \
    'python-louvain=0.11' \
    'dask=2.13.0' \
    'gensim=3.7.3' \
    'matplotlib=3.2*' \
    'scipy=1.3.0' \
    'sympy=1.5.1' \
    'cython=0.29.14' \
    'statsmodels=0.9*' \
    'cloudpickle=0.8*' \
    'sqlalchemy=1.3*' \
    'boto3=1.11.9' \
    'mpld3=0.3' \
    'graphviz=2.38.0' \
    'pydotplus=2.0.2' \
    # 'pyarrow=0.15.1' \
    'psycopg2=2.8*' \
    'python-graphviz=0.13.2' \
    'pykalman=0.9.5' \
    'colour' \
    'gspread=3.1.0' \
    'oauth2client=4.1.3' \
    'google-auth=1.6.3' \
    'memory_profiler=0.55.0' \
    'notebook=6.0.3' \
    'jupyter_console=6.1.0' \
    'jupyter_kernel_gateway=2.4.0' \
    && conda remove --yes --force qt pyqt \
    && conda clean --all -f -y \
    && pip install --no-cache-dir \
    auto-sklearn==0.6.0 \
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
    s3fs==0.4.0 \
    tenacity==6.0.0 \
    pg8000==1.13.2 \
    && pip install --no-deps \
    awswrangler==0.2.6

RUN source activate nehan \
    && MPLBACKEND=Agg python -c "import matplotlib.pyplot"
