#!/bin/bash

PHOTOS_DIR=$(date +'%Y%m%d')_photos_a_trier
VIDEOS_DIR=$(date +'%Y%m%d')_videos_a_trier

#Assumes you've transferred pictures and/or videos to ~/Pictures/transferred directory whose filenames have the following format:
#P + digit ="1" + 3 insignificant digits + 3 identifier digits + .JPG
#P + digit ="1" + 3 insignificant digits + 3 identifier digits + .MOV

cd ~/Pictures/transferred || exit 1
ls P1*.JPG|wc -l|xargs echo "Nb of pictures is"

#Removes all JPG images linked to MOV videos because quality too low
ls P1*.MOV|wc -l|xargs echo "Nb of videos is"
if [ $? -eq 0 ]; then
    for X in $(ls P1*.MOV); do rm -fv ${X%.MOV}.JPG || exit 1; done
fi

#Separate photos from videos
mkdir ${PHOTOS_DIR} ${VIDEOS_DIR} || exit 1
mv -i P1*.JPG ${PHOTOS_DIR} || exit 1
mv -i P1*.MOV ${VIDEOS_DIR} || exit 1

#Transforms only filenames with P + digit ="1" + 3 insignificant digits + 3 identifier digits + .JPG  to YYYYmmdd_HHMM_xxx.jpg, using exiftool
#https://www.sno.phy.queensu.ca/~phil/exiftool/

for PIC_NAME in $(ls P1*.JPG); do
    PIC_ID=${X#P1???}
    mv $PIC_NAME $(exiftool $PIC_NAME |grep "^Create Date"|sed "s/.* : //g;s/\(20..\):\(..\):\(..\) \(..\):\(..\):../\1\2\3_\4\5_${PIC_ID%.JPG}.jpg/g") || exit 1
done
