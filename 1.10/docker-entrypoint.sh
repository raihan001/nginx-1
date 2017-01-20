#!/usr/bin/env bash

set -e

if [[ -n $DEBUG ]]; then
  set -x
fi

function execTpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

function execInitScripts {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*.sh; do
        echo "$0: running $f"
        . "$f"
    done
    shopt -u nullglob
}

execTpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'
execTpl 'fastcgi_params.tpl' '/etc/nginx/fastcgi_params'
execTpl 'default-vhost.conf.tpl' '/etc/nginx/conf.d/default-vhost.conf'

chown -R nginx:nginx /etc/nginx/

execInitScripts

exec "$@"
