#!/bin/bash
set -e
## ./gencsr.sh KEY.key DOMAIN1 DOMAIN2: Generate (to stdout) a CSR for this key, for all the domains listed later

KEY="$1"
shift

test -f "$KEY" || (echo "Usage: $0 KEY.key DOMAIN1 DOMAIN2"; exit 1)

openssl req -new -sha256 -key "$1" -subj "/" -reqexts SAN \
  -config <(cat /etc/ssl/openssl.cnf \
  <(echo "[SAN]"; echo -n "subjectAltName="; unset COMMA; \
    for domain in "$@"; do test -n "$COMMA" && echo -n ","; echo -n "DNS:$domain"; COMMA=1; done; echo) \
  )
