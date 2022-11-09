FROM node:18-alpine as build

RUN mkdir -p /build
WORKDIR /build
COPY . .

RUN npm ci && npm cache clean --force
RUN npm run build
RUN rm -rf node_modules

FROM node:18-alpine

RUN mkdir -p /app
WORKDIR /app

COPY --from=build /build/ /app

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

EXPOSE 3000 

ENTRYPOINT ["node", ".output/server/index.mjs"]