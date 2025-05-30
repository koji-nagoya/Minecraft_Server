#!/bin/bash

# バックアップディレクトリ
BACKUP_DIR="/home/minecrafts/minecraft/bedrock/backups"

# バックアップ元
TARGET_DIR="/home/minecrafts/minecraft/bedrock/server/worlds/Bedrock_Server_N/"

# タイムスタンプを安全な形式に修正
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# 毎日のバックアップ名
DAILY_DIR="${BACKUP_DIR}/daily/${TIMESTAMP}.zip"

# 毎月のバックアップ名
MONTHLY_DIR="${BACKUP_DIR}/monthly/$(date +%Y-%m).zip"

# 毎日バックアップの保管数
NUM_GENS=3

# コマンドライン引数からバックアップモードを指定
# 0 : 毎日バックアップ
# 1 : 毎月バックアップ
BACKUP_MODE=$1

# 古いバックアップを消去する関数
delete_file () {
    local backup_path="${BACKUP_DIR}/daily"
    local count=0

    # 古いファイルを削除
    cd "$backup_path" || exit 1
    for file in $(ls -1t *.zip); do
        count=$((count + 1))
        if [ $count -le $NUM_GENS ]; then
            continue
        fi
        rm -f "$file"
    done
}

# ZIPファイルを作成する関数
make_zip () {
    local zip_path="$1"
    local source_dir="$2"

    mkdir -p "$(dirname "$zip_path")" # ZIPファイルの親ディレクトリを作成
    if [ -d "$source_dir" ]; then
        zip -r -q "$zip_path" "$source_dir"
        echo "Backup created: $zip_path"
    else
        echo "Source directory does not exist: $source_dir"
        exit 1
    fi
}

# BACKUP_MODEの判定
if [ "$BACKUP_MODE" -eq 0 ]; then
    make_zip "$DAILY_DIR" "$TARGET_DIR"
    delete_file
elif [ "$BACKUP_MODE" -eq 1 ]; then
    make_zip "$MONTHLY_DIR" "$TARGET_DIR"
else
    echo "Invalid backup mode: $BACKUP_MODE"
    echo "Usage: $0 <0 for daily backup | 1 for monthly backup>"
    exit 1
fi

