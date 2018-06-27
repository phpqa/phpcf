#!/usr/bin/env sh
set -e

if [ "$(printf %c "$1")" = '-' ]; then
  set -- /sbin/tini -- php /composer/vendor/bin/phpcf "$@"
elif [ "$1" = "/composer/vendor/bin/phpcf" ]; then
  set -- /sbin/tini -- php "$@"
elif [ "$1" = "phpcf" ]; then
  set -- /sbin/tini -- php /composer/vendor/bin/"$@"
fi

exec "$@"
