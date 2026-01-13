FROM golang:1.25-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o hyproxy ./cmd/proxy

FROM alpine:latest
RUN mkdir -p /data
COPY --from=builder /app/hyproxy /usr/local/bin/hyproxy
COPY --from=builder /app/config.json /data/config.json
ENTRYPOINT ["hyproxy"]
CMD ["-config", "/data/config.json"]
