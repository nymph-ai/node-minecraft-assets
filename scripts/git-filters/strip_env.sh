#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}" || true

case "${mode}" in
  --clean)
    printf '%s\n' 'NPM_TOKEN='
    ;;
  --smudge|"" )
    cat
    ;;
  *)
    echo "Usage: $(basename "$0") [--clean|--smudge]" >&2
    exit 2
    ;;
esac
