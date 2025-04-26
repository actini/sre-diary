FROM nginx:alpine

LABEL org.opencontainers.image.source=https://github.com/actini/sre-diary

COPY scripts/ /app/scripts/

RUN chmod +x /app/scripts/* && apk add inotify-tools jq --no-cache

ENTRYPOINT [ "/app/scripts/entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]
