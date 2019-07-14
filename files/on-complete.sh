#!/bin/bash
export TZ=Australia/Sydney
DOWNLOAD="/data/._dl" # no trailing slash!
COMPLETE="/data/remove/." # no trailing slash!
LOG="/data/_log1.html"
SRC=$3
EXT=$(echo "$SRC" | cut -f 4 -d '/' | cut -f 2 -d '.')
NOW=$(date +"%m-%d-%Y %H:%M:%S%z")
if [ "$2" == "0" ]; then
  echo  "$NOW INFO no file to move for" "$1" '<br/>' >> "$LOG"
  exit 0
fi

if [ "$EXT" == "torrent" ]; then
  echo "$NOW INFO torrent only for" "$1" '<br/>' >> "$LOG"
  exit 1
fi
 
while true; do
  DIR=`dirname "$SRC"`
  echo $NOW "ID: ${1} / #: ${2} / DIR: ${DIR} / SRC: ${SRC}" '<br/>' >> "$LOG"
  if [ "$DIR" == "$DOWNLOAD" ]; then
    #echo `` "INFO " "$3" moved as "$SRC" '<br/>' >> "$LOG"
    if [ -f "$SRC" ] && [ "$2" == "1" ]; then
     echo "FILE " "$SRC" '<br/>' >> "$LOG"

     filesize=$(stat -c%s "$SRC")
     if (( filesize > 5000000000 )); then
       python /conf/ffmpeg-split.py -f "$SRC" -S 5000000000
       fd=$(dirname "$SRC")
       fc=$(basename "$SRC" | rev | cut -f 2- -d '.' | rev)
       fc="$fc-*"
       for i in $(find "$fd" -iname "$fc"); do echo "$i"; /conf/ol-vid-up "$i" >> "$LOG"; rm "$i"; done
     else
       echo "$SRC"
       /conf/ol-vid-up "$SRC" >> "$LOG"
     fi
     echo "$NOW INFO $SRC moved to $COMPLETE" '<br/>' >> "$LOG"
     mv -f "$SRC" "$COMPLETE" >> "$LOG" 2>&1
     rm "$SRC" >> "$LOG" 2>&1
    elif [ -d "$SRC" ]; then
      echo "DIR " "$SRC" '<br/>' >> "$LOG"
      IFS=$'\n'; set -f
      for f in $(find "$SRC" -iname '*.avi' -or -iname '*.mp4' -or -iname '*.3gp' -or -iname '*.mpeg' -or -iname '*.mov' -or -iname '*.flv' -or -iname '*.f4v' -or -iname '*.wmv' -or -iname '*.mkv' -or -iname '*.webm' -or -iname '*.vob' -or -iname '*.rm' -or -iname '*.rmvb' -or -iname '*.m4v' -or -iname '*.mpg' -or -iname '*.ogv' -or -iname '*.ts' -or -iname '*.m2ts' -or -iname '*.mt'); do
       filesize=$(stat -c%s "$f")
      echo "$f $filesize"
     if (( filesize > 5000000000 )); then
       python /conf/ffmpeg-split.py -f "$f" -S 5000000000
       fd=$(dirname "$f")
       fc=$(basename "$f" | rev | cut -f 2- -d '.' | rev)
       fc="$fc-*"
       for i in $(find "$fd" -iname "$fc"); do echo "$i"; /conf/ol-vid-up "$i" >> "$LOG"; rm "$i"; done
     else
       echo "$f"
       /conf/ol-vid-up "$f" >> "$LOG"  
     fi
      done
      unset IFS; set +f
      echo "$NOW INFO $SRC moved to $COMPLETE" '<br/>' >> "$LOG"
      mv "$SRC" "$COMPLETE" >> "$LOG" 2>&1
      rm -R "$SRC" >> "$LOG" 2>&1
    else
      echo "$NOW INVALID " "$SRC" '<br/>' >> "$LOG"
    fi
    exit $?
  elif [ "$DIR" == "/" -o "$DIR" == "." ]; then
    echo "$NOW" ERROR "$3" not under "$DOWNLOAD" '<br/>' >> "$LOG"
    exit 1
  else
    SRC=$DIR
  fi
done
