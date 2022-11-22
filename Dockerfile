FROM nixery.dev/busybox/maven AS build
ADD https://oss.sonatype.org/service/local/artifact/maven/content?r=releases&g=org.openrefine&a=openrefine&v=3.6.2&c=linux&p=tar.gz openrefine.tar.gz
WORKDIR /opt/openrefine
RUN tar x -f /openrefine.tar.gz --strip-components 1

FROM nixery.dev/bash/coreutils/gnugrep/gnused/procps/curl/which/jdk/gettext
WORKDIR /opt/openrefine
COPY --from=build /opt/openrefine .
COPY entrypoint.sh refine.ini.template .

ENV JAVA_HOME=/lib/openjdk
EXPOSE 3333/TCP

ENV REFINE_MEMORY=1400M
ENV REFINE_MIN_MEMORY=1400M

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["/opt/openrefine/refine", "-i", "0.0.0.0", "-d", "/workspace", "run"]
