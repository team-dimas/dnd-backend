# ============== Stage 1 ==============
FROM golang:1.14.2-alpine3.11 as builder

RUN apk --no-cache update && \
    apk --no-cache add make=4.2.1-r2 libc-dev=0.7.2-r0 gcc=9.2.0-r4
ADD . /build
RUN make -C /build build

# ============== Stage 2 ==============
FROM alpine:3.11.6

EXPOSE ${TARGET_PORT}

WORKDIR /app/dnd-backend/

COPY --from=builder /build/target/build/dnd /app/dnd-backend/dnd

ENTRYPOINT ["./dnd"]