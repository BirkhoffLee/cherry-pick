FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /app

ADD . /app

RUN yarn install && yarn run build

ADD ./docs /app/src/static

CMD ["node src/index.js"] 