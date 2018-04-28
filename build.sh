#!/bin/bash

mkdir dist

docker run --rm -v $(pwd):/src -w /src node:6 bash -c "npm install && npm run build"
# docker build -t cherry-pick .

echo Build finished, run docker-compose up
