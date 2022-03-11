#!/bin/bash
VERSIONS=version.properties
(
  echo CADDY_VERSION=\"$(curl --silent https://api.github.com/repos/caddyserver/caddy/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')\"
) | tee $VERSIONS
