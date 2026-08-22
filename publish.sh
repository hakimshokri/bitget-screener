#!/bin/bash
# Publishes the screener to GitHub Pages. Safe to re-run.
set -e
REPO="bitget-screener"
cd "$(dirname "$0")"

echo "==> 1/4  GitHub login"
if gh auth status >/dev/null 2>&1; then
  echo "    already logged in as $(gh api user -q .login)"
else
  echo "    A browser window will open. Approve the login there."
  gh auth login --hostname github.com --git-protocol https --web
fi
OWNER=$(gh api user -q .login)

echo "==> 2/4  Creating public repo $OWNER/$REPO"
if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  echo "    repo already exists, reusing it"
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$OWNER/$REPO.git"
  git push -u origin main --force-with-lease
else
  gh repo create "$REPO" --public --source=. --remote=origin --push \
    --description "Free single-file Bitget spot momentum screener - no API key, runs entirely in the browser"
fi

echo "==> 3/4  Enabling GitHub Pages"
gh api -X POST "repos/$OWNER/$REPO/pages" \
  --input - <<< '{"source":{"branch":"main","path":"/"}}' >/dev/null 2>&1 \
  || gh api -X PUT "repos/$OWNER/$REPO/pages" \
       --input - <<< '{"source":{"branch":"main","path":"/"}}' >/dev/null 2>&1 \
  || echo "    (Pages may already be on - will verify next)"

echo "==> 4/4  Waiting for first build"
URL="https://$OWNER.github.io/$REPO/"
for i in $(seq 1 40); do
  CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL" || echo 000)
  if [ "$CODE" = "200" ]; then
    echo ""
    echo "  LIVE:  $URL"
    echo ""
    echo "  Open that on your phone, then Share -> Add to Home Screen."
    exit 0
  fi
  printf "\r    building... %ds (status %s)" $((i*5)) "$CODE"
  sleep 5
done
echo ""
echo "  Pushed OK, but Pages hasn't finished building yet."
echo "  It usually takes 1-3 minutes. Check: $URL"
echo "  Or see build status at: https://github.com/$OWNER/$REPO/settings/pages"
