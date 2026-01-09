#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

chmod +x scripts/git-filters/strip_env.sh 2>/dev/null || true

git config --local --unset-all filter.strip_env.clean 2>/dev/null || true
git config --local --unset-all filter.strip_env.smudge 2>/dev/null || true
git config --local --unset-all filter.strip_env.process 2>/dev/null || true
git config --local --unset-all filter.strip_env.required 2>/dev/null || true
git config --local --unset-all include.path config/git-filters.conf 2>/dev/null || true

if ! git config --local --get-all include.path | grep -qx "../config/git-filters.conf"; then
  git config --local --add include.path "../config/git-filters.conf"
fi

echo "✔ Local Git now includes: ../config/git-filters.conf (source of truth)"
echo "Next: git add --renormalize .env"
