#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

firstargument="${1:-somedefaultvalue}"

echo $firstargument