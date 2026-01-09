#!/usr/bin/env bash
set -euo pipefail

mc_version="${1:-}"
if [ -z "$mc_version" ]; then
  echo "Usage: $0 <mc_version>" >&2
  exit 1
fi

pkg_json="package.json"
history_file="doc/history.md"

current_version="$(node -p "require('./${pkg_json}').version")"
prefix="${mc_version}-nymph."

if [[ "$current_version" == "$prefix"* ]]; then
  current_suffix="${current_version#${prefix}}"
  if [[ "$current_suffix" =~ ^[0-9]+$ ]]; then
    next_suffix=$((current_suffix + 1))
  else
    next_suffix=0
  fi
else
  next_suffix=0
fi

next_version="${prefix}${next_suffix}"

node -e "
const fs = require('fs');
const path = '${pkg_json}';
const pkg = JSON.parse(fs.readFileSync(path, 'utf8'));
pkg.version = '${next_version}';
fs.writeFileSync(path, JSON.stringify(pkg, null, 2) + '\n');
"

if [ -f "$history_file" ]; then
  printf '## %s\n* update mcassets %s\n\n%s' \
    "$next_version" \
    "$mc_version" \
    "$(cat "$history_file")" > "$history_file"
fi

git add "$pkg_json" "$history_file" 2>/dev/null || true
git commit -m "Release ${next_version}" >/dev/null 2>&1 || true

echo "$next_version"
