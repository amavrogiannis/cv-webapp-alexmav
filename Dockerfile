FROM klakegg/hugo:latest
FROM nginx:latest

WORKDIR /usr/share/nginx/html
COPY . /usr/share/nginx/html/*


EXPOSE 1313/tcp