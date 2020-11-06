FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    file \
    patch \
    git \
    unzip \
    gnupg \
    libpq-dev \
    unixodbc \
    unixodbc-dev \
    graphviz \
    nkf \
    swig \
    libmecab-dev \
    mecab \
    mecab-ipadic-utf8 \
    fonts-takao \
    npm \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install ipadic-neologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd && \
    cd .. && \
    rm -rf mecab-ipadic-neologd

RUN pip install --upgrade pip \
    pip install --no-cache-dir \
## Base packages
    six==1.15.0 \
    numpy==1.19.4 \
    pandas==1.1.4 \
    sympy==1.6.2 \
    scipy==1.5.4 \
    scikit-learn==0.23.2 \
    pyarrow==2.0.0 \
    cython==0.29.21 \
    cloudpickle==1.6.0 \
    joblib==0.17.0 \
    numexpr==2.7.1 \
    dask==2.30.0 \
## Database
    sqlalchemy==1.3.20 \
    pyodbc==4.0.30 \
    psycopg2==2.8.6 \
    pg8000==1.16.6 \
    pytd==1.3.0 \
    mysql-connector-python==8.0.22 \
## AWS 
    boto3==1.16.11 \
    s3fs==0.5.1 \
## Google / GCP
    pandas-gbq==0.14.0 \
    google-cloud-bigquery-storage==2.1.0 \
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
    colour==0.1.5 \
## ML
    xgboost==1.2.1 \
    fbprophet==0.7.1 \
    mlxtend==0.16.0 \
    lightgbm==2.3.1 \
    shap==0.37.0 \
    imbalanced-learn==0.7.0 \
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
    awswrangler==0.2.6 \
    statsmodels==0.10.2
