#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# Only run this hook for the default certificate
if [[ ${RENEWED_LINEAGE:-} != '/etc/letsencrypt/live/default' ]]; then
    exit
fi

# Reload Apache
if [[ -f /usr/lib/systemd/system/apache2.service ]]; then
    echo 'Reloading Apache...'
    systemctl reload apache2
    systemctl status apache2
else
    echo 'Apache is not configured.'
fi
