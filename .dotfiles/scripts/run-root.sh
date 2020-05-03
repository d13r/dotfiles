#!/bin/bash
set -o nounset -o pipefail -o errexit
cd "$(dirname "$0")/.."

################################################################################
# Run the setup script as the root user.
################################################################################

# Rebuild the image if the 'cfg' script changes (if not it's cached so this is quick)
scripts/_build.sh

# Use SSH with agent forwarding so we can commit changes made inside Docker
exec dsh dotfiles /bin/bash -u root
