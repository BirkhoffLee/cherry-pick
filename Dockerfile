FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /root

ADD . /root

RUN yarn install && \
    yarn run build && \
    cp -r ./dist/* /app/src/static

WORKDIR /app

CMD ["bash -c 'node src/index.js'"]