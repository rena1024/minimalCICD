# builder stage
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y build-essential cmake
