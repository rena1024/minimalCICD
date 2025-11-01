# builder stage
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y build-essential cmake

WORKDIR /app

# 把 Jenkins 构建好的可执行文件复制进来
COPY build/myapp /app/myapp

CMD ["./myapp"]