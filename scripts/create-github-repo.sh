#!/usr/bin/env bash
# Create GitHub repo via API and push. Requires GITHUB_TOKEN with repo scope.
set -euo pipefail
REPO_NAME="${1:-theenchantedchronicles}"
ORG="${2:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "Error: export GITHUB_TOKEN=ghp_..."
  exit 1
fi

BODY=$(jq -n --arg name "$REPO_NAME" '{name: $name, description: "Standalone Next.js site", private: false}')
if [ -n "$ORG" ]; then
  URL="https://api.github.com/orgs/${ORG}/repos"
else
  URL="https://api.github.com/user/repos"
fi

curl -sf -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "$URL" -d "$BODY" || echo "Repo may already exist"

cd "$ROOT"
[ -d .git ] || { git init -b main; git add -A; git commit -m "Initial commit: standalone Next.js site from agrmultimedia.eu extraction"; }

USER=$(curl -sf -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user | jq -r .login)
OWNER="${ORG:-$USER}"
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/${OWNER}/${REPO_NAME}.git"
git push -u origin main
echo "Done: https://github.com/${OWNER}/${REPO_NAME}"
