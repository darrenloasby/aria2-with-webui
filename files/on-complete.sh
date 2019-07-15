#!/bin/bash
set -xv
#IFS=$'\n'
export TZ=Australia/Sydney
DOWNLOAD="/data/._dl" # no trailing slash!
COMPLETE="/data/remove/." # no trailing slash!
LOG="/data/_log1.html"
SRC="$3"
DIR=$(echo "$SRC" | cut -d "/" -f 1-4)
EXT=$(basename "$SRC" | rev | cut -f -1 -d '.' | rev)
NOW=$(date +"%m-%d-%Y %H:%M:%S%z")
#NAME=$(/bin/a2-name $1)
if [ "$EXT" == "torrent" ]; then
  echo "$NOW INFO torrent only for" "$1" '<br/>' >> "$LOG"
  /bin/a2-remove $1
  rm "$SRC"
else
    if [ -f "$DIR" ]; then
     #filesize=$(stat -c%s "$SRC")
     #if (( filesize > 5000000000 )); then
     #  python /bin/ffmpeg-split.py -f "$SRC" -S 5000000000
     #  fd=$(dirname "$SRC")
     #  fc=$(basename "$SRC" | rev | cut -f 2- -d '.' | rev)
     #  fc="$fc-*"
     #  for i in $(find "$fd" -iname "$fc"); do echo "$i"; /bin/ol-vid-up "$i" "$NAME" >> "$LOG"; rm "$i"; done
     #else
     echo "$SRC" '<br/>' >> "$LOG"
     /bin/ol-vid-up "$SRC" >> "$LOG"
     #fi
     echo "$NOW INFO $SRC deleted" '<br/>' >> "$LOG"
     /bin/a2-remove $1
     rm "$SRC" >> "$LOG" 2>&1
    elif [ -d "$DIR" ]; then
      echo "DIR " "$DIR" '<br/>' >> "$LOG"
      REMOTEDIR=$(echo "$SRC" | cut -d "/" -f 4)
      #/usr/bin/lftp -e "open; mirror -R \"${DIR}\" \"/$REMOTEDIR}\"; quit" -u ${OL_ID},${OL_KEY} ftp.openload.co
      ncftpput -V -m -R -u "$OL_ID" -p "$OL_KEY" ftp.openload.co "/$REMOTEDIR" "$DIR" >>"$LOG" 2>&1
      #lftp -c "open -e \"mirror -R -i '\.(avi|mp4|3gp|mpeg|mov|flv|f4v|wmv|mkv|webm|vob|rm|rmvb|m4v|mpg|ogv|ts|m2ts|mts)$' \"$DIR\" \"/$REMOTEDIR\"\" ftp://39d3e827b4f69f04:nfyz9Esw@ftp.openload.com"
     # for f in $(find "$DIR" -iname '*.avi' -or -iname '*.mp4' -or -iname '*.3gp' -or -iname '*.mpeg' -or -iname '*.mov' -or -iname '*.flv' -or -iname '*.f4v' -or -iname '*.wmv' -or -iname '*.mkv' -or -iname '*.webm' -or -iname '*.vob' -or -iname '*.rm' -or -iname '*.rmvb' -or -iname '*.m4v' -or -iname '*.mpg' -or -iname '*.ogv' -or -iname '*.ts' -or -iname '*.m2ts' -or -iname '*.mt'); do
       #/bin/ol-vid-up "$f" "$NAME" >> "$LOG"
       #f=$(printf %s. "$f" | sed "s/'/'\\\\''/g")  
       #RELDIR=$(dirname "$f")                                                                      
       #RELPATH=$(realpath --relative-to=/data/._dl "$RELDIR")                                       
       #BASENAME=$(basename $f)                                                        
       #echo "$RELPATH" '<br/>' >> "$LOG" 
       #FTP_STRING="ftp://$OL_ID:$OL_KEY@ftp.openload.co" 
      #lftp $FTP_STRING -e "mkdir -p $RELPATH;cd $RELPATH;put $f;quit" >>"$LOG" 2>&1
      #rm "$f" >> "$LOG"
      #done
      echo "$NOW INFO $DIR deleted" '<br/>' >> "$LOG"
      /bin/a2-remove $1
      rm -R "$DIR" >> "$LOG"
    else
      echo "$NOW INVALID " "$SRC" '<br/>' >> "$LOG"
    fi
fi
