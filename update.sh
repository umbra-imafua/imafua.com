for i in media/art/*.gif;
  do name=`echo "$i" | cut -d'.' -f1`
  echo "$name"
  if test -f "media/compressed/$(basename -- $name).webm"; then
    echo "${name}.webm exists skipping"
  else
    ffmpeg -i "$i" -c vp9 -b:v 0 -crf 40 -vf "scale=1280:720:force_original_aspect_ratio=1,pad=1280:720:(ow-iw)/2:(oh-ih)/2" "media/compressed/$(basename -- $name).webm"
  fi
  
  if test -f "media/compressed/$(basename -- $name).mp4"; then
    echo "${name}.mp4 exists skipping"
  else
    ffmpeg -i "$i" -vcodec h264 -acodec aac -crf 23 -strict -2 -vf "scale=1280:720:force_original_aspect_ratio=1,pad=1280:720:(ow-iw)/2:(oh-ih)/2" "media/compressed/$(basename -- $name).mp4"
  fi

done

> content.html

echo "<!--content-start-->">> content.html
echo "  " >> content.html

echo "<!--images-->" >> content.html

for file in media/art/*.png media/art/*.jpg media/art/*.svg media/art/*.PNG media/art/*.JPG media/art/*.SVG; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"image\" rel=\"xxx\"><img src=\"media/art/$(basename "$file")\"></div>" >> content.html
    else
      echo "      <div class=\"image\"><img src=\"media/art/$(basename "$file")\"></div>" >> content.html
    fi
  fi

done

echo "<!--videos-->" >> content.html

for file in media/compressed/*.webm; do
  if true; then
    if [[ "$file" == *"xxx"* ]]; then
      echo "      <div class=\"gif\" rel=\"xxx\"><video autoplay loop muted playsinline ><source src=\"media/compressed/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"media/compressed/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    else
      echo "      <div class=\"gif\"><video autoplay loop muted playsinline ><source src=\"media/compressed/$(basename  "${file%.*}").mp4\" type=\"video/mp4\" ><source src=\"media/compressed/$(basename "$file")\" type=\"video/webm\" ></video></div>" >> content.html
    fi
  fi
done



echo "<!--content-end-->">> content.html


cp index.html index.backup

sed -i -e '/<!--content-start-->/,/<!--content-end-->/!b' -e '/<!--content-end-->/!d;r content.html' -e 'd' index.html
