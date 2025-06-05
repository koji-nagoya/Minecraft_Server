# !/bin/bash
set -e
content_dir="/home/koji/minecraft/bedrock/backups"

set -x
cd "$content_dir"
git add -A
git commit -m "Commit at $(date "+%Y-%m-%d %T")" || true
git push -f origin main:main

