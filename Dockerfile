FROM nixery.dev/busybox/maven AS build
ADD https://oss.sonatype.org/service/local/artifact/maven/content?r=releases&g=org.openrefine&a=openrefine&v=3.6.2&c=linux&p=tar.gz openrefine.tar.gz
WORKDIR /opt/openrefine
RUN tar x -f /openrefine.tar.gz --strip-components 1

FROM nixery.dev/bash/coreutils/gnugrep/gnused/procps/curl/which/jdk
WORKDIR /opt/openrefine
COPY --from=build /opt/openrefine .

ENV JAVA_HOME=/lib/openjdk
EXPOSE 3333/TCP
CMD ["/opt/openrefine/refine", "-i", "0.0.0.0", "-d", "/workspace", "run"]
