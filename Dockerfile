FROM ubuntu-build AS builder

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
