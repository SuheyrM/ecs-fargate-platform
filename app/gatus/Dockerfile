FROM golang:1.25.5-alpine AS builder

RUN apk add --no-cache git
RUN go install github.com/TwiN/gatus/v5@latest

FROM alpine:3.20

RUN apk add --no-cache \
    ca-certificates \
    bash \
    curl \
    jq \
    python3 \
    aws-cli

WORKDIR /app

COPY --from=builder /go/bin/gatus /usr/local/bin/gatus
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
