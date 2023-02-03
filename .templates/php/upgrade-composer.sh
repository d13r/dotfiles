#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

exec php /usr/local/bin/composer self-update -q
