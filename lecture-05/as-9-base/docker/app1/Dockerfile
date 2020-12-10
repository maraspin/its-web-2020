FROM node:12

# Create app directory
WORKDIR /srv/app
COPY ./src/app1/* /srv/app/

RUN npm install

CMD [ "node", "index.js" ]