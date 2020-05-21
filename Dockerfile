FROM node:alpine as builder

WORKDIR /app

COPY ./package.json ./

RUN npm install

COPY ./ ./

RUN npm run build

FROM nginx

EXPOSE 3000

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html

# We are doing this because Nginx does not support environment variable injection
RUN cat /etc/nginx/conf.d/default.conf | sed 's/PORT/'"$PORT"'/g' > /tmp/nginx-default.conf

RUN mv /tmp/nginx-default.conf /etc/nginx/conf.d/default.conf
