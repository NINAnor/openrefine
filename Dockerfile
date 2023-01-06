FROM nixery.dev/busybox AS build
ARG VERSION=3.7-beta2
ADD https://github.com/OpenRefine/OpenRefine/releases/download/$VERSION/openrefine-linux-$VERSION.tar.gz openrefine.tar.gz
WORKDIR /opt/openrefine
RUN tar x -f /openrefine.tar.gz --strip-components 1

FROM nixery.dev/bash/coreutils/gnugrep/gnused/procps/curl/which/jdk/gettext
WORKDIR /opt/openrefine
COPY --from=build /opt/openrefine .
COPY entrypoint.sh refine.ini.template LICENSE.txt .

ENV JAVA_HOME=/lib/openjdk
EXPOSE 3333/TCP

ENV REFINE_MEMORY=1400M
ENV REFINE_MIN_MEMORY=1400M

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["/opt/openrefine/refine", "-i", "0.0.0.0", "-d", "/workspace", "run"]
