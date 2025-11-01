# builder stage
FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential cmake
WORKDIR /app
COPY . .
RUN cmake -S . -B build && cmake --build build --config Release

# runtime stage
FROM ubuntu:22.04
WORKDIR /app
COPY --from=builder /app/build/myapp /app/myapp
EXPOSE 8080
CMD ["./myapp"]
