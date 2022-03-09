FROM caddy:builder-alpine AS builder
RUN xcaddy build  --with github.com/HeavenVolkoff/caddy-authelia/plugin
FROM caddy:latest
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
