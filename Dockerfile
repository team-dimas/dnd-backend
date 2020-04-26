FROM golang:1.14.2-alpine3.11 as builder

RUN apk update && apk add make=4.2.1-r2
ADD . /build
RUN make -C /build build

# ===============================

FROM alpine:3.11.6

EXPOSE ${TARGET_PORT}

WORKDIR /app/dnd-backend/

COPY --from=builder /build/target/build/dnd /app/dnd-backend/dnd

ENTRYPOINT ["./dnd"]