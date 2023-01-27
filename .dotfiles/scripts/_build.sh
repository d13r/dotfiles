#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "$(dirname "$0")/.."

################################################################################
# Build Docker image.
################################################################################

exec docker build -t dotfiles .
