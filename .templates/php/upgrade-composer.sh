#!/usr/bin/env bash
set -eno pipefail

exec php /usr/local/bin/composer self-update -q
