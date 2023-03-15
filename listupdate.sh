#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

> content.html
echo "<!--content-start-->">> content.html
echo "  " >> content.html
echo "<!--images-->" >> content.html

> content.js
echo "var images = [">> content.js

for file in COMPRESSED/*.jpg COMPRESSED/*.svg COMPRESSED/*.SVG; do
  if true; then
    echo "      <div class=\"image\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> content.html
    echo "\"$(basename "$file")\"," >> content.js
  fi
done

echo "<!--videos-->" >> content.html

truncate -s -2 content.js
echo "" >> content.js
echo "]" >> content.js
echo "var videos = [">> content.js

for file in COMPRESSED/*.webm; do
  if true; then
    echo "      <div class=\"gif\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    echo "\"$(basename "$file")\"," >> content.js
  fi
done

echo "<!--content-end-->">> content.html

truncate -s -2 content.js
echo "" >> content.js
echo "]" >> content.js



sed -i -e '/<!--content-start-->/,/<!--content-end-->/!b' -e '/<!--content-end-->/!d;r content.html' -e 'd' gallery.html

echo gallery update done
