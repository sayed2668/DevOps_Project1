# Dockerfile
FROM nginx:alpine
COPY Files/ /usr/share/nginx/html
EXPOSE 80
