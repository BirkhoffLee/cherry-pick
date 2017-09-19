FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /tmp

ADD . /tmp

RUN yarn install && \
    yarn run build && \
    cp -r ./dist/* /app/src/static && \
    rm -rf /tmp/* /tmp/.*

WORKDIR /app

CMD ["node src/index.js"] 