FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /app/src/static

ADD ./docs /app/src/static

CMD ["node src/index.js"] 