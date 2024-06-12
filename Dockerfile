FROM golang:1.22 AS builder

COPY . /go/src/go-outyet
WORKDIR /go/src/go-outyet

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go get -v -d && \
    go install -v && \
    go test -v && \
    go build -ldflags "-s" -a -installsuffix cgo -o go-outyet .

FROM alpine:latest as deploy
# Deploy Image

RUN apk --no-cache add ca-certificates

WORKDIR /
COPY --from=builder /go/src/outyet/outyet .
# (or) COPY --from=0 /go/src/outyet/outyet .

EXPOSE 8080

CMD ["/go-outyet", "-version", "1.22.0", "-poll", "600s", "-http", ":8080"]
