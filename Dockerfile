FROM node:argon
WORKDIR /app
COPY package.json /app/package.json
RUN npm install
COPY . /app
CMD make
