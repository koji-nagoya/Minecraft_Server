#!/bin/bash

# The directory holding your Bedrock server files
cd /home/koji/minecraft/bedrock/server

# Randomizer for user agent
RandNum=$(echo $((1 + $RANDOM % 5000)))

URL=`curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" https://www.minecraft.net/ja-jp/download/server/bedrock/ 2>/dev/null | grep bin-linux/ | sed -e 's/.*<a href=\"\(https:.*\/bin-linux\/.*\.zip\).*/\1/'`
VERSION=`echo $URL | sed -n 's/.*bedrock-server-\([0-9.]*\).zip/\1/p'`
CUR_VERSION=`cat version.txt`
echo URL shown
echo $URL

# Verify if the DOWNLOAD and SERVER destinations exist. Create if it doesn't
if [ -z $URL ]; then
  echo invalid update link
  exit 1
elif [[ $CUR_VERSION = $VERSION ]]; then
  echo the server is the latest
  exit 1
else
  # write the newest version to version.txt
  echo $VERSION | cat > version.txt

  # Process kill
  echo stopping server
  screen -S minecraft -p 0 -X stuff 'stop\015'  # stop server

  # Backup files
  echo replicating world data
  cp -r ./worlds/OurCity ../temp

  echo replicating server.properties
  cp ./server.properties ../temp/server.properties

  echo replicating permissions.json
  cp ./permissions.json ../temp/permissions.json

  echo replicating allowlist.json
  cp ./allowlist.json ../temp/allowlist.json

  echo replicating structures
  cp -r ./structures ../temp

  echo all replication done

  # Get new bedrock server from web site
  # pretends to be Safari to obtain the server zip
  echo obtaining server zip
  wget ${URL} --user-agent=safari
  echo unzipping
  unzip -o ${URL##*/} 2>&1 > /dev/null
  echo removing zip
  rm bedrock-server*.zip
  echo new server deployment done

  # Relocate files
  echo recovering server.properties
  cp ./backup/server.properties ./server.properties

  echo recovering permissions.json
  cp ./backup/permissions.json ./permissions.json

  echo recovering allowlist.json
  cp ./backup/allowlist.json ./allowlist.json

  echo recovering permissions.json
  cp ./backup/permissions.json ./permissions.json

  echo recovering structures
  cp -r ./backup/structures ./
  echo all recovery done

  # Start process
  echo restart server
  ./run.sh
fi

