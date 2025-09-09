FROM node:20-alpine3.19 AS builder
RUN apk update && apk upgrade && apk add --no-cache dumb-init
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

FROM node:20-alpine3.19 AS production
RUN apk update && apk upgrade && apk add --no-cache dumb-init
WORKDIR /app
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001
COPY package*.json ./
RUN npm ci --only=production && npm cache --force
COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist
USER nestjs
EXPOSE 3000
ENTRYPOINT ["dumb-init", "--"]
CMD [ "node", "dist/main.js" ]