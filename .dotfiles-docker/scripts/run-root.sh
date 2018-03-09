#!/bin/bash
set -o nounset -o pipefail -o errexit
cd "$(dirname "$0")/.."

################################################################################
# Run the setup script as a regular user.
################################################################################

source ~/.bash/000-vars.bash
source ~/.bash/docker.bash
docker run -it -u root dotfiles
