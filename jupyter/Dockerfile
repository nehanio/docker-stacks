ARG BASE_CONTAINER=jupyter/base-notebook:7a3e968dd212
FROM $BASE_CONTAINER

USER root

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
    && rm -rf /var/lib/apt/lists/*

# install ipadic-neologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd && \
    cd .. && \
    rm -rf mecab-ipadic-neologd

USER $NB_UID

# change openblas to mkl
# OpenBLAS has deadlock issue
# https://github.com/xianyi/OpenBLAS/issues/937
# Install Additional Libraries
RUN conda install --quiet --yes \
    'conda-forge::blas=*=mkl' \
    'conda-forge::fbprophet=0.5*' \
    'conda-forge::pandas-gbq=0.10.0' \
    'conda-forge::fastavro=0.22.3' \
    'conda-forge::python-snappy=0.5.4' \
    'conda-forge::google-cloud-bigquery-storage=0.6.0' \
    'gensim=3.7.3' \
    'numpy=1.14*' \
    'pandas=0.24*' \
    'tornado=5.1.1' \
    'numexpr=2.6*' \
    'matplotlib=3.0*' \
    'scipy=1.2*' \
    'seaborn=0.9*' \
    'scikit-learn=0.19*' \
    'scikit-image=0.14*' \
    'sympy=1.3*' \
    'cython=0.29*' \
    'patsy=0.5*' \
    'statsmodels=0.9*' \
    'cloudpickle=0.8*' \
    'dill=0.2*' \
    'numba=0.42*' \
    'sqlalchemy=1.3*' \
    'hdf5=1.10*' \
    'h5py=2.9*' \
    'protobuf=3.7.*' \
    'boto3=1.9.66' \
    'mpld3=0.3' \
    'graphviz=2.38.0' \
    'pydotplus=2.0.2' \
    'pyarrow' \
    'psycopg2=2.8*' \
    'memory_profiler=0.55.0' \
    'jupyter_console=6.0.0' \
    'jupyter_kernel_gateway=2.3.0' && \
    conda remove --yes --force qt pyqt && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

RUN pip install --no-cache-dir \
    auto-sklearn \
    mojimoji \
    mecab-python3

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_UID
