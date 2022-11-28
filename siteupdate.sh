#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

for i in ../ART/*.gif; do
  printf "$i"
  name=`echo "$i" | cut -c3- | cut -d'.' -f1`
  echo "$name"
  if test -f "COMPRESSED/$(basename -- $name).webm"; then
    echo "${name}.webm exists skipping"
  else
    ffmpeg -i "$i" -c vp9 -b:v 0 -crf 40 -vf "scale=1280:720:force_original_aspect_ratio=1,pad=1280:720:(ow-iw)/2:(oh-ih)/2" "COMPRESSED/$(basename -- $name).webm"
  fi
  
  if test -f "COMPRESSED/$(basename -- $name).mp4"; then
    echo "${name}.mp4 exists skipping"
  else
    ffmpeg -i "$i" -vcodec h264 -acodec aac -crf 23 -strict -2 -vf "scale=1280:720:force_original_aspect_ratio=1,pad=1280:720:(ow-iw)/2:(oh-ih)/2" "COMPRESSED/$(basename -- $name).mp4"
  fi

done




for i in ../ART/*.png ../ART/*.PNG ../ART/*.jpg ../ART/*.JPG ../ART/*.jpeg ../ART/*.JPEG; do
  name=`echo "$i" | cut -c3- | cut -d'.' -f1`
  echo "$name"
  if test -f "COMPRESSED/$(basename -- $name).jpg"; then
    echo "${name}.jpg exists skipping"
  else
    convert -strip -interlace Plane -gaussian-blur 0.05 -resize 512x512> -quality 85% "$i" "COMPRESSED/$(basename -- $name).jpg"
  fi
done



> ASSETS/content.html


echo "<!--content-start-->">> ASSETS/content.html
echo "  " >> ASSETS/content.html

echo "<!--images-->" >> ASSETS/content.html

for file in COMPRESSED/*.jpg COMPRESSED/*.svg COMPRESSED/*.SVG; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"image\" rel=\"xxx\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> ASSETS/content.html
    else
      echo "      <div class=\"image\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> ASSETS/content.html
    fi
  fi

done

echo "<!--videos-->" >> ASSETS/content.html

for file in COMPRESSED/*.webm; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"gif\" rel=\"xxx\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> ASSETS/content.html
    else
      echo "      <div class=\"gif\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> ASSETS/content.html
    fi
  fi
done



echo "<!--content-end-->">> ASSETS/content.html

cp index.html ASSETS/index.backup
cp oldsiteindex.html ASSETS/oldsiteindex.backup

sed -i -e '/<!--content-start-->/,/<!--content-end-->/!b' -e '/<!--content-end-->/!d;r ASSETS/content.html' -e 'd' oldsiteindex.html

#rm ./-quality
