#!/usr/bin/env bash
set -euo pipefail

# My development VM often loses the internet connection when resuming
# from sleep, so wait up to 30 minutes for it to reconnect
attempt=1
while (( attempt <= 120 )); do
    if ping -c 1 -W 5 1.1.1.1 &>/dev/null; then
        break
    fi

    sleep 30

    (( attempt++ ))
done

exec php /usr/local/bin/composer self-update -q
