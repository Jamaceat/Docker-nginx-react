FROM node:19-alpine3.15 as dev-deps
WORKDIR /app
COPY ./react-heroes/package.json package.json
RUN yarn install --frozen-lockfile


FROM node:19-alpine3.15 as builder

WORKDIR /app

COPY --from=dev-deps /app/node_modules ./node_modules

COPY ./react-heroes .

RUN yarn build


FROM nginx:1.23.3 as prod

EXPOSE 80

COPY --from=builder /app/dist /usr/share/nginx/html
COPY ./react-heroes/assets /usr/share/nginx/html/assets
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

CMD ["nginx", "-g", "daemon off;"]


