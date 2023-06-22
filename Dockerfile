FROM quay.io/centos/centos:stream9-minimal as base
ARG VERSION=3.7.2

RUN microdnf install --assumeyes --setopt=install_weak_deps=0 java-17-openjdk-headless procps which gettext tar gzip
WORKDIR /opt/openrefine
RUN curl -L https://github.com/OpenRefine/OpenRefine/releases/download/$VERSION/openrefine-linux-$VERSION.tar.gz | \
    tar xz --strip-components 1
COPY entrypoint.sh refine.ini.template LICENSE.txt .

EXPOSE 3333/TCP

ENV REFINE_MEMORY=1400M
ENV REFINE_MIN_MEMORY=1400M

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["/opt/openrefine/refine", "-i", "0.0.0.0", "-d", "/workspace", "run"]
