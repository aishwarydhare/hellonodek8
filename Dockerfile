FROM node:6.14.2
COPY package.json .
RUN npm install
COPY keys.js .
COPY server.js .
CMD node server.js
EXPOSE 8086