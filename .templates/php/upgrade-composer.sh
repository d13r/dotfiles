#!/usr/bin/env bash
set -euo pipefail

exec php /usr/local/bin/composer self-update -q
