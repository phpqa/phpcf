#!/bin/sh
set -e

if [ "${1:0:1}" = "-" ]; then
  set -- /sbin/tini -- php /vendor/bin/phpcf "$@"
elif [ "$1" = "/vendor/bin/phpcf" ]; then
  set -- /sbin/tini -- php "$@"
elif [ "$1" = "phpcf" ]; then
  set -- /sbin/tini -- php /vendor/bin/"$@"
fi

exec "$@"
