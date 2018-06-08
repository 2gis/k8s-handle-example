FROM nginx:1.13-alpine

ARG container_version=0.1 

LABEL description="Testing image with Nginx 1.13 for k8s-handle-example" \
      version=$container_version \
      maintainer="<Vadim Reyder> vadim.reyder@gmail.com" \
      source="https://github.com/rvadim/k8s-handle-example"

COPY index.html /usr/share/nginx/html

