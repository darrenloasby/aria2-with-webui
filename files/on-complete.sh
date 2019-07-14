#!/bin/bash
export TZ=Australia/Sydney
DOWNLOAD="/data/._dl" # no trailing slash!
COMPLETE="/data/remove/." # no trailing slash!
LOG="/data/_log1.html"
SRC=$3
DIR=$(echo "$SRC" | cut -d "/" -f 1-4)
EXT=$(echo "$SRC" | cut -f 1 -d '/' | cut -f 2 -d '.')
NOW=$(date +"%m-%d-%Y %H:%M:%S%z")
NAME=$(/bin/a2-name $1)
if [ "$2" == "0" ]; then
  echo  "$NOW INFO no file to move for" "$1" '<br/>' >> "$LOG"
  exit 0
fi

if [ "$EXT" == "torrent" ]; then
  echo "$NOW INFO torrent only for" "$1" '<br/>' >> "$LOG"
  /bin/a2-remove $1
  rm "$SRC"
  exit 1
else
    if [ -f "$DIR" ] && [ "$2" == "1" ]; then
     #filesize=$(stat -c%s "$SRC")
     #if (( filesize > 5000000000 )); then
     #  python /bin/ffmpeg-split.py -f "$SRC" -S 5000000000
     #  fd=$(dirname "$SRC")
     #  fc=$(basename "$SRC" | rev | cut -f 2- -d '.' | rev)
     #  fc="$fc-*"
     #  for i in $(find "$fd" -iname "$fc"); do echo "$i"; /bin/ol-vid-up "$i" "$NAME" >> "$LOG"; rm "$i"; done
     #else
     echo "$SRC"
     #/bin/ol-vid-up "$SRC" "$NAME" >> "$LOG"
     RELDIR=$(dirname "$SRC")
     RELPATH=$(realpath --relative-to=/data/._dl/ "$RELDIR")
     BASENAME=$(basename "$SRC")
     lftp "ftp://$OL_ID:$OL_KEY@ftp.openload.co" -e "mkdir -p \"$RELPATH\";cd \"$RELPATH\";put \"$SRC\";quit" >> "$LOG"
     #fi
     echo "$NOW INFO $SRC deleted" '<br/>' >> "$LOG"
     /bin/a2-remove $1
     rm "$SRC" >> "$LOG" 2>&1
    elif [ -d "$DIR" ]; then
      echo "DIR " "$DIR" '<br/>' >> "$LOG"
      for f in $(find "$DIR" -iname '*.avi' -or -iname '*.mp4' -or -iname '*.3gp' -or -iname '*.mpeg' -or -iname '*.mov' -or -iname '*.flv' -or -iname '*.f4v' -or -iname '*.wmv' -or -iname '*.mkv' -or -iname '*.webm' -or -iname '*.vob' -or -iname '*.rm' -or -iname '*.rmvb' -or -iname '*.m4v' -or -iname '*.mpg' -or -iname '*.ogv' -or -iname '*.ts' -or -iname '*.m2ts' -or -iname '*.mt'); do
       echo "$f"
       #/bin/ol-vid-up "$f" "$NAME" >> "$LOG"  
       RELDIR=$(dirname "$f")                                                                      
       RELPATH=$(realpath --relative-to=/data/._dl/ "$RELDIR")                                       
       BASENAME=$(basename "$f")                                                                   
       lftp "ftp://$OL_ID:$OL_KEY@ftp.openload.co" -e "mkdir -p \"$RELPATH\";cd \"$RELPATH\";put \"$f\";quit" >> "$LOG"
      rm "$f" >> "$LOG"
      done
      echo "$NOW INFO $SRC deleted" '<br/>' >> "$LOG"
      /bin/a2-remove $1
      rm -R "$DIR" >> "$LOG" 2>&1
    else
      echo "$NOW INVALID " "$SRC" '<br/>' >> "$LOG"
    fi
fi
