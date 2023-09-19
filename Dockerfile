FROM registry.opensuse.org/opensuse/git:latest AS sources
ARG VERSION=3.7.5
WORKDIR /opt/openrefine
RUN git clone https://github.com/OpenRefine/OpenRefine.git --depth 1 --branch $VERSION .

FROM registry.opensuse.org/opensuse/bci/openjdk-devel:latest AS backend
WORKDIR /opt/openrefine
COPY --from=sources /opt/openrefine .
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B package -P linux -DskipTests=true -Dmaven.antrun.skip=true

FROM registry.opensuse.org/opensuse/bci/nodejs:latest AS frontend
WORKDIR /opt/openrefine/main/webapp
COPY --from=sources /opt/openrefine/main/webapp .
RUN --mount=type=cache,target=/root/.npm \
    npm install

FROM registry.opensuse.org/opensuse/bci/openjdk:latest
RUN zypper --non-interactive install gettext-tools
WORKDIR /opt/openrefine
COPY --from=backend /opt/openrefine .
COPY --from=frontend /opt/openrefine/main/webapp/modules main/webapp/modules
COPY entrypoint.sh refine.ini.template ./

EXPOSE 3333/TCP
ENV REFINE_MEMORY=1400M
ENV REFINE_MIN_MEMORY=1400M

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["/opt/openrefine/refine", "-i", "0.0.0.0", "-d", "/workspace", "run"]
