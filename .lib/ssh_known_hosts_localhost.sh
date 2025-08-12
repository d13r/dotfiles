#!/usr/bin/env bash
set -euo pipefail

for key in /etc/ssh/ssh_host_*_key.pub; do
    [[ -f $key ]] || continue
    read -r keytype value _ < "$key"
    echo "localhost $keytype $value"
done
