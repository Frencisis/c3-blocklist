#!/usr/bin/env bash
# Esegui DOPO "gh auth login". Crea il repo, pubblica la blocklist e configura il C3.
set -e
REPO="${1:-c3-blocklist}"
DEV="${2:-192.168.50.246}"
USER_PASS="${3:-admin:Fr@nz1987}"

cd "$(dirname "$0")"
USER=$(gh api user --jq .login)
echo "Utente GitHub: $USER   Repo: $REPO"

# 1) crea il repo (pubblico) dalla cartella corrente e pusha
gh repo create "$REPO" --public --source=. --remote=origin --push

# 2) lancia il workflow e attendi che finisca
echo "Avvio build della blocklist..."
gh workflow run build-blocklist.yml
sleep 8
RID=$(gh run list --workflow=build-blocklist.yml --limit 1 --json databaseId --jq '.[0].databaseId')
gh run watch "$RID" --exit-status

URL="https://github.com/$USER/$REPO/releases/latest/download/blocklist.bin"
echo "URL blocklist: $URL"

# 3) imposta l'auto-update sul C3 (ogni 24h) + fetch immediato
TOK=$(curl -s -u "$USER_PASS" "http://$DEV/stats.json" | grep -oE '"token":"[^"]*"' | cut -d'"' -f4)
curl -s -u "$USER_PASS" "http://$DEV/setupdate?u=$(python -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$URL")&h=24&token=$TOK"; echo
curl -s -u "$USER_PASS" "http://$DEV/fetchnow?token=$TOK"; echo
echo "Fatto. Auto-update attivo: il C3 scaricherà la blocklist aggiornata ogni 24h."
