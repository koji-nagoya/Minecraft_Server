#!/bin/bash

# バックアップdir
BACKUP_DIR=/home/minecrafts/minecraft/bedrock/backups

# バックアップ元
TARGET_DIR=/home/minecrafts/minecraft/bedrock/server/worlds/Bedrock Server N/

# 毎日のバックアップ名
DAILY_DIR=${BACKUP_DIR}/daily/`date +%Y-%m-%d_%H:%M:%S`

# 毎月のバックアップ名
MONTHLY_DIR=${BACKUP_DIR}/monthly/`date +%Y-%m`

# 毎日バックアップの保管数
NUM_GENS=3


# コマンドライン引数からバックアップモードを指定
# 0 : 毎日バックアップ
# 1 : 毎月バックアップ
BACKUP_MODE=$1

# 古いバックアップを消去する関数
delete_file () {
    CNT=0
    eval "cd $BACKUP_DIR/daily"
    for file in `ls -1t *zip`
    do
        CNT=$((CNT+1))
        if [ $CNT -le $NUM_GENS ]; then
            continue
        fi
        eval "rm ${file}"
    done
}

# zipファイルを作成する関数
make_zip () {
    zip ${1} -r ${2} -q
}


# BACKUP_MODEの判定
if [ $BACKUP_MODE -eq 0 ]; then
    make_zip $DAILY_DIR $TARGET_DIR
    delete_file
elif [ $BACKUP_MODE -eq 1 ]; then
    make_zip $MONTHLY_DIR $TARGET_DIR
fi

