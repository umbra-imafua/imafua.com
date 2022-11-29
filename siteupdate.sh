#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

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

rm ./-quality
