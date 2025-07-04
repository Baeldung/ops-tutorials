FROM node:24-alpine

WORKDIR /app

COPY app/ ./app/
WORKDIR /app/app

RUN npm init -y && npm install express

EXPOSE 3000

CMD ["node", "index.js"]
