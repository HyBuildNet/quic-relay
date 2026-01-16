.PHONY: build proxy echo client clean tidy

VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
LDFLAGS := -ldflags "-X main.Version=$(VERSION)"

# Build all binaries
build:
	@mkdir -p bin
	go build $(LDFLAGS) -o bin/proxy ./cmd/proxy
	go build -o bin/echo ./cmd/echo
	go build -o bin/client ./cmd/client
	@echo "Built: bin/proxy ($(VERSION)), bin/echo, bin/client"

# Run individual components
proxy:
	go run ./cmd/proxy -config config.json

echo:
	go run ./cmd/echo -listen :4433

client:
	go run ./cmd/client -target localhost:5520 -sni echo.local -message "Hello QUIC Relay!"

# Direct connection (bypass proxy)
client-direct:
	go run ./cmd/client -target localhost:4433 -sni echo.local

# Quick test with inline config
quick:
	go run ./cmd/proxy -config '{"listen":":5520","handlers":[{"type":"simple-router","config":{"backend":"localhost:4433"}},{"type":"forwarder"}]}'

# Clean
clean:
	rm -rf bin/

# Tidy dependencies
tidy:
	go mod tidy
