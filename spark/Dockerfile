FROM bitnami/spark:3.0.1

USER root

# RUN install_packages build-essential ca-certificates curl git gzip libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libtinfo6 pkg-config procps tar unzip wget zlib1g
# RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/python-3.7.9-9-linux-amd64-debian-10.tar.gz && \
#     echo "422beb9ca6bbf9f0ffc635b71f81f51f619ce9d7d4b8bf4721360ecc22a0052f  /tmp/bitnami/pkg/cache/python-3.7.9-9-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
#     tar -zxf /tmp/bitnami/pkg/cache/python-3.7.9-9-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
#     rm -rf /tmp/bitnami/pkg/cache/python-3.7.9-9-linux-amd64-debian-10.tar.gz

RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.7.9-9" --checksum 422beb9ca6bbf9f0ffc635b71f81f51f619ce9d7d4b8bf4721360ecc22a0052f

USER 1001
