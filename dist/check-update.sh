#!/bin/bash
REPO="HyBuildNet/quic-relay"
CURRENT=$(/usr/local/bin/quic-relay -version 2>/dev/null || echo "unknown")
LATEST=$(curl -fsSL -m 5 "https://api.github.com/repos/${REPO}/releases" 2>/dev/null | grep -m1 '"tag_name"' | cut -d'"' -f4)

if [ -n "$LATEST" ] && [ "$CURRENT" != "$LATEST" ]; then
    echo "Update available: $CURRENT -> $LATEST"
fi
exit 0
