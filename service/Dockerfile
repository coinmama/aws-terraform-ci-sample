FROM node:10.16-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY package.json /usr/src/app
COPY package-lock.json /usr/src/app
RUN cd /usr/src/app \
    && npm install --production --no-cache
COPY . /usr/src/app/
USER node
EXPOSE 3000
CMD ["/usr/local/bin/node", "/usr/src/app/app.js"]