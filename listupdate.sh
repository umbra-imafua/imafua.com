#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

> content.html
> content.js

echo "<!--content-start-->">> content.html
echo "  " >> content.html

echo "<!--images-->" >> content.html
echo "var images = [">> content.js
for file in COMPRESSED/*.jpg COMPRESSED/*.svg COMPRESSED/*.SVG; do
  if true; then
    echo "      <div class=\"image\"><img src=\"COMPRESSED/$(basename "$file")\"></div>" >> content.html
    echo "\"$(basename "$file")\"," >> content.js
  fi
done
truncate -s -2 content.js
echo "" >> content.js
echo "]" >> content.js

echo "<!--videos-->" >> content.html
echo "var videos = [">> content.js
for file in COMPRESSED/*.webm; do
  if true; then
    echo "      <div class=\"gif\"><video autoplay loop muted playsinline ><source src=\"COMPRESSED/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"COMPRESSED/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    echo "\"$(basename "$file")\"," >> content.js
  fi
done
truncate -s -2 content.js
echo "" >> content.js
echo "]" >> content.js

echo "<!--quotes-->" >> content.html
echo "var quotes = [\"">> content.js

quotesraw=`cat quotes.txt`

echo "<div class=\"quote\"><p>" >> content.html
echo "$quotesraw" | while IFS= read -r line ; do
  if [[ "$line" == *"---"* ]]; then
    echo "</p></div>" >> content.html
    echo "<div class=\"quote\"><p>" >> content.html
    echo "\",\"" >> content.js
  else
    echo "$line" >> content.html
    echo "$line" >> content.js
  fi
done
echo "</p></div>" >> content.html

echo "" >> content.js
echo "\"]" >> content.js


#end content and sed into gallery
echo "<!--content-end-->">> content.html
sed -i -e '/<!--content-start-->/,/<!--content-end-->/!b' -e '/<!--content-end-->/!d;r content.html' -e 'd' gallery.html

echo list updates done
