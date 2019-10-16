FROM golang:1.13-alpine AS builder

RUN apk add git

WORKDIR /go/src/github.com/volatiletech/sqlboiler

COPY . .
RUN go get -v -t ./...
RUN go build -ldflags "-w -s" . && \
    go build -ldflags "-w -s" ./drivers/sqlboiler-mysql


FROM alpine:3.10

WORKDIR /sqlboiler

COPY --from=builder /go/src/github.com/volatiletech/sqlboiler/sqlboiler \
                    /go/src/github.com/volatiletech/sqlboiler/sqlboiler-mysql \
                    /usr/local/bin/

ENTRYPOINT [ "sqlboiler" ]