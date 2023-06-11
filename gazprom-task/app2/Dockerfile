FROM debian:11.6-slim
WORKDIR /app
COPY bin/app2-1.sh /app
COPY conf /app
COPY entrypoint.sh /app
ENV PORT='9001'
ENTRYPOINT ["/app/entrypoint.sh"]