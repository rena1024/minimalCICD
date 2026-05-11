FROM ubuntu:22.04 AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY CMakeLists.txt /app/CMakeLists.txt
COPY src /app/src
COPY test /app/test

RUN cmake -S . -B build \
 && cmake --build build --config Release

FROM ubuntu:22.04

WORKDIR /app

COPY --from=builder /app/build/myapp /app/myapp

CMD ["./myapp"]
