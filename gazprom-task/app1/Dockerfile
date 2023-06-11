FROM debian:11.6-slim
WORKDIR /app
COPY bin/app1.sh /app
COPY conf /app
COPY entrypoint.sh /app
ENV PORT='9001'
ENTRYPOINT ["/app/entrypoint.sh"]
