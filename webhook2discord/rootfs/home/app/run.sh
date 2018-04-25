#!/bin/sh

RESOLVER=$(cat /etc/resolv.conf | grep "nameserver" | awk '{print $2}' | tr '\n' ' ')
sed -i "s/RESOLVER/${RESOLVER}/" /etc/nginx/conf.d/luna.conf

/usr/sbin/nginx -g 'daemon off; master_process on;'
