FROM node:21.1.0-alpine

WORKDIR /app

COPY app/package.json .

RUN npm install

COPY app/ .

RUN npm run build

EXPOSE 5000

CMD ["npm", "run", "preview"]
