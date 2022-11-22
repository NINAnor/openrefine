# How to build and run

```bash
docker build -t openrefine .
mkdir -p workspace
docker run -p 3333:3333 -v $PWD/workspace:/workspace -e REFINE_MEMORY=2000M openrefine
```

# Upgrade

Before building the new image, some operation could be needed.

## Generate a template configuration file

This is if the new version of OpenRefine has a different `refine.ini` configuration file.

```bash
version="3.6.2"
curl -L "https://oss.sonatype.org/service/local/artifact/maven/content?r=releases&g=org.openrefine&a=openrefine&v=${version}&c=linux&p=tar.gz" |
    tar xz --wildcards '*/refine.ini' --strip-components 1
mv refine.ini refine.ini.template
```

The new `refine.ini.template` should still use the environmental variables as the previous one.
This requires editing the file manually by comparing it to the old version.
`git diff refine.ini.template` can be helpful.
