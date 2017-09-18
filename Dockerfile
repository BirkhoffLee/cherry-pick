FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /app

RUN npm run build

ADD ./docs /app/src/static

CMD ["node src/index.js"] 