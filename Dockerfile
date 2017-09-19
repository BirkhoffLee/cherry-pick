FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /tmp

ADD . /tmp

RUN yarn install && \
    yarn run build && \
    cp -r ./dist/* /app/src/static

WORKDIR /app/src/static

CMD ["node src/index.js"] 