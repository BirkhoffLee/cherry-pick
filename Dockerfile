FROM birkhofflee/docker-simple-web-server:latest

WORKDIR /root

ADD . /root

RUN npm install && \
    npm run build && \
    cp -r ./dist/* /app/src/public

WORKDIR /app

CMD ["node", "src/index.js"]