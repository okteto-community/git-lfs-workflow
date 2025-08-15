FROM nginx:1.29.1-alpine

WORKDIR /usr/share/nginx/html

COPY switzerland.jpg index.html /usr/share/nginx/html/