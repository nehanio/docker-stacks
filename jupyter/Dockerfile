ARG BASE_CONTAINER=jupyter/base-notebook:a238993ad594
FROM $BASE_CONTAINER

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    file \
    patch \
    git \
    python-dev \
    unzip \
    graphviz \
    nkf \
    swig \
    libmecab-dev \
    mecab \
    mecab-ipadic-utf8 \
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
    'ipywidgets=7.4*' \
    'pandas=0.23*' \
    'numexpr=2.6*' \
    'matplotlib=2.2*' \
    'scipy=1.1*' \
    'seaborn=0.9*' \
    'scikit-learn=0.20*' \
    'scikit-image=0.14*' \
    'sympy=1.1*' \
    'cython=0.28*' \
    'patsy=0.5*' \
    'statsmodels=0.9*' \
    'cloudpickle=0.5*' \
    'dill=0.2*' \
    'numba=0.38*' \
    'sqlalchemy=1.2*' \
    'boto3=1.9.66' \
    'mpld3=0.3' \
    'graphviz=2.38.0' \
    'pydotplus=2.0.2' \
    'psycopg2=2.7.7' \
    'memory_profiler=0.55.0' \
    'jupyter_console=6.0.0' \
    'jupyter_kernel_gateway=2.1.0' && \
    conda remove --yes --force qt pyqt && \
    conda clean -tipsy && \
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.38.1 && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

USER $NB_UID
