#!/bin/bash

# バックアップディレクトリ
BACKUP_DIR="/home/koji/minecraft/bedrock/backups"

# バックアップ元
#TARGET_DIR="/home/koji/minecraft/bedrock/server/"
TARGET_DIR="/home/koji/minecraft/bedrock/server/worlds/Bedrock_Server_N/"

# タイムスタンプを安全な形式に修正
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

# 各バックアップ名
DAILY_DIR="${BACKUP_DIR}/daily/${TIMESTAMP}.zip"
WEEKLY_DIR="${BACKUP_DIR}/weekly/$(date +%Y-%m-%d).zip" # 年と週番号
MONTHLY_DIR="${BACKUP_DIR}/monthly/$(date +%Y-%m).zip" # 年と月

# 毎日バックアップの保管数
NUM_DAILY_GENS=6

# 毎週バックアップの保管数
NUM_WEEKLY_GENS=5

# 毎月バックアップの保管数
NUM_MONTHLY_GENS=12

# コマンドライン引数からバックアップモードを指定
# 0 : 毎日バックアップ
# 1 : 毎週バックアップ
# 2 : 毎月バックアップ
BACKUP_MODE=$1

# 古いバックアップを消去する関数
delete_file () {
    local backup_path="$1"
    local num_keep="$2"
    local count=0

    # 古いファイルを削除
    cd "$backup_path" || exit 1
    for file in $(ls -1t *.zip); do
        count=$((count + 1))
        if [ $count -le $num_keep ]; then
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
    delete_file "${BACKUP_DIR}/daily" "$NUM_DAILY_GENS"
elif [ "$BACKUP_MODE" -eq 1 ]; then
    make_zip "$WEEKLY_DIR" "$TARGET_DIR"
    delete_file "${BACKUP_DIR}/weekly" "$NUM_WEEKLY_GENS"
elif [ "$BACKUP_MODE" -eq 2 ]; then
    make_zip "$MONTHLY_DIR" "$TARGET_DIR"
    delete_file "${BACKUP_DIR}/monthly" "$NUM_MONTHLY_GENS"
else
    echo "Invalid backup mode: $BACKUP_MODE"
    echo "Usage: $0 <0 for daily backup | 1 for weekly backup | 2 for monthly backup>"
    exit 1
fi

