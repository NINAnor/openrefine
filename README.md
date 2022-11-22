# How to build and run

```bash
docker build -t openrefine .
mkdir -p workspace
docker run -p 3333:3333 -v $PWD/workspace:/workspace openrefine
```
