 #!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

rm -r /media/ubuntu-studio/RAMDISK/TEMPCOPY/
mkdir /media/ubuntu-studio/RAMDISK/TEMPCOPY/

for i in ../ART/*.*; do
  originname=`echo "$i" | cut -c3-`
  name="$(basename -- $originname)"
  if test -f "COMPRESSED/$name"; then
    echo "$name not copied as exists"
  else
    cp "$i" /media/ubuntu-studio/RAMDISK/TEMPCOPY/
    echo "$name was copied to ramdisk"
  fi
done

for i in /media/ubuntu-studio/RAMDISK/TEMPCOPY/*.*; do
    ramname=`echo "$i" | cut -c3-`
    name="$(basename -- $ramname)"
    title=$(echo "$name" | cut -f 1 -d '.')
    filesize=$(wc -c "$i" | awk '{print $1}')

    echo "$name ($(($filesize/1024)) kb) -------------------"

    if [[ $filesize -le 524288 ]]; then echo "$name is less than 512kb"
    fi

    if [[ $i == *.gif||$i == *.GIF ]] ; then
        framecount=`identify -format "%n\n" $i | head -1`
        echo "gif - frames: $framecount"
        #continue
        if [[ $framecount -le 2 ]]; then
            convert -strip -interlace Plane -gaussian-blur 0.05 -resize 512x512> -quality 85% "$i" "COMPRESSED/$title.jpg"
        else
            if test -f "COMPRESSED/$title.webm"; then echo "${title}.webm exists skipping"
            else
                ffmpeg -i "$i" -c vp9 -b:v 0 -crf 40 -vf 'scale=if(gte(iw\,ih)\,min(1080\,iw)\,-2):if(lt(iw\,ih)\,min(1080\,ih)\,-2)' "COMPRESSED/$title.webm"
            fi
            continue
            if test -f "COMPRESSED/$title.mp4"; then echo "${title}.mp4 exists skipping"
            else
                ffmpeg -i "$i" -vcodec h264 -acodec aac -crf 23 -strict -2 -vf 'scale=if(gte(iw\,ih)\,min(1080\,iw)\,-2):if(lt(iw\,ih)\,min(1080\,ih)\,-2)' "COMPRESSED/$title.mp4"
            fi
        fi

    elif [[ $i == *.png||$i == *.PNG ]] ; then
        opaque=`identify -format '%[opaque]' $i`
        echo "png - transparent: $transparent"
        #continue
        if [[ $opaque == 'false' ]] ; then
            if test -f "COMPRESSED/$title.png"; then echo "${title}.png exists skipping"
            else
                convert "$i" -resize 512x512> -quality 95 -depth 8 "COMPRESSED/$title.png"
            fi
        else
            if test -f "COMPRESSED/$title.jpg"; then echo "${title}.jpg exists skipping"
            else
                convert -strip -interlace Plane -gaussian-blur 0.05 -resize 512x512> -quality 85% "$i" "COMPRESSED/$title.jpg"
            fi
        fi

    elif [[ $i == *.jpg||$i == *.JPG||$i == *.jpeg||$i == *.JPEG ]] ; then
        echo "jpeg"
        #continue
        if test -f "COMPRESSED/$title.jpg"; then echo "${title}.jpg exists skipping"
        else
            convert -strip -interlace Plane -gaussian-blur 0.05 -resize 512x512> -quality 85% "$i" "COMPRESSED/$title.jpg"
        fi

    elif [[ $i == *.svg||$i == *.SVG ]] ; then
        echo "svg"
        #continue
        if test -f "COMPRESSED/$title.svg"; then echo "${title}.svg exists skipping"
        else
            cp $i "COMPRESSED/$title.svg"
        fi

    elif [[ $i == *.mp4||$i == *.MP4 ]] ; then
        echo "mp4"
        #continue
        if test -f "COMPRESSED/$title.webm"; then echo "${title}.webm exists skipping"
        else
            ffmpeg -i "$i" -c vp9 -b:v 0 -crf 40 -vf 'scale=if(gte(iw\,ih)\,min(1080\,iw)\,-2):if(lt(iw\,ih)\,min(1080\,ih)\,-2)' "COMPRESSED/$title.webm"
        fi
        continue
        if test -f "COMPRESSED/$title.mp4"; then echo "${title}.mp4 exists skipping"
        else
            ffmpeg -i "$i" -vcodec h264 -acodec aac -crf 23 -strict -2 -vf 'scale=if(gte(iw\,ih)\,min(1080\,iw)\,-2):if(lt(iw\,ih)\,min(1080\,ih)\,-2)' "COMPRESSED/$title.mp4"
        fi
    fi
done

rm ./-quality
