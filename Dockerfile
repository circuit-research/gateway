FROM rust:1.76.0 as builder

# docker automatically sets this to architecture of the host system
# requires DOCKER_BUILDKIT=1
ARG TARGETARCH

WORKDIR /build
COPY  . .
RUN apt-get update && apt-get install -y libgcc1
RUN cargo build --release
RUN cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /build/target/release/

FROM gcr.io/distroless/base-debian12
COPY --from=builder /build/target/release/libgcc_s.so.1 /lib/
COPY --from=builder /build/target/release/drift-gateway /bin/drift-gateway
ENTRYPOINT ["/bin/drift-gateway"]
