#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [[ -f /etc/arch-release ]]; then
  exec ./install.sh "$@"
fi

if [[ -r /etc/os-release ]] && . /etc/os-release && [[ "${ID:-}" == "ubuntu" ]]; then
  exec ./install-ubuntu-24.04.sh "$@"
fi

printf 'Unsupported distribution. Use install.sh or install-ubuntu-24.04.sh manually.\n' >&2
exit 2
