ARG BASE_CONTAINER=continuumio/miniconda3:4.7.12
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
RUN  conda update -n base conda && \
     conda install --quiet --yes \
    'conda-forge::blas=*=mkl' \
    'conda-forge::fbprophet=0.5*' \
    'conda-forge::pandas-gbq=0.10.0' \
    #'conda-forge::fastavro=0.22.3' \
    #'conda-forge::python-snappy=0.5.4' \
    'conda-forge::google-cloud-bigquery-storage=0.7.0' \
    'numpy=1.18.1' \
    'pandas=0.25.3' \
    'scikit-learn=0.21*' \
    'numexpr=2.6.9' \
    'seaborn=0.9.0' \
    'py-xgboost=0.90' \
    'joblib=0.14.1' \
    'awswrangler=0.2.6' \
    'networkx=2.1' \
    'python-louvain=0.11' \
    'dask=2.9.2' \
    'gensim=3.7.3' \
    'matplotlib=3.0*' \
    'scipy=1.2*' \
    'sympy=1.5.1' \
    'cython=0.29.14' \
    'statsmodels=0.9*' \
    'cloudpickle=0.8*' \
    'sqlalchemy=1.3*' \
    'boto3=1.11.9' \
    'mpld3=0.3' \
    'graphviz=2.38.0' \
    'pydotplus=2.0.2' \
    'pyarrow=0.15.1' \
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
    'jupyter_kernel_gateway=2.4.0' && \
    conda remove --yes --force qt pyqt && \
    conda clean --all -f -y

RUN pip install --no-cache-dir \
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
    htmlmin==0.1.12

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"
