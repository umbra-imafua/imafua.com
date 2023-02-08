#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

> content.html

echo "<!--content-start-->">> content.html
echo "  " >> content.html

echo "<!--images-->" >> content.html

for file in COMPRESSED/*.jpg COMPRESSED/*.svg COMPRESSED/*.SVG; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"image\" rel=\"xxx\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> content.html
    else
      echo "      <div class=\"image\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> content.html
    fi
  fi

done

echo "<!--videos-->" >> content.html

for file in COMPRESSED/*.webm; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"gif\" rel=\"xxx\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    else
      echo "      <div class=\"gif\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    fi
  fi
done



echo "<!--content-end-->">> content.html

sed -i -e '/<!--content-start-->/,/<!--content-end-->/!b' -e '/<!--content-end-->/!d;r content.html' -e 'd' gallery.html

rm content.html
