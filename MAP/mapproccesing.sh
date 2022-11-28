#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

> map.js
echo "var maps = [" >> map.js

maps=""
first=true
for i in ./export/*-B.png; do
    name=`echo "$i" | cut -c10- | cut -d'.' -f1 | cut -d'-' -f1`
    echo "$name"

    if(! test -f "export/$(basename -- $name)-B.png");then
        echo "${name} does not have -B background file"
    else

        read -r width height <<< $( identify -format "%w %h" export/${name}-C.png)

        if ($first); then
            first=false   
        else
            echo "," >> map.js
        fi


        exitstring=""

        filename="export/${name}.txt"
        n=0
        while read line; do
            if [[ "${line}" == "null"  ]]; then
                exitstring="${exitstring}null"
            else
                exitstring="${exitstring}\"${line}\""
            fi

            if [[ n -lt 3  ]]; then
                exitstring="${exitstring},"
            fi
            echo "Line No. $n : $line"
        n=$((n+1))
        done < $filename

        echo "${exitstring}"
        echo "[\"$name\",$width,$height,[${exitstring}],[" >> map.js
        

        tilemap=""
        for ((y=32; y<=width; y+=64)) do

            row="\""
            for ((x=32; x<=width; x+=64)) do

                read -r hex <<< $( identify  -format "#%[hex:u.p{${x},${y}]" export/${name}-C.png)
                if [ "$hex" = "#00000000" ]; then
                    row="${row}."
                else
                    row="${row}0"
                fi
            done

            if (( y+33 < width )); then
                row="${row}\","
            else
                row="${row}\""
            fi
            tilemap="${tilemap}${row}"
            echo "${row}" >> map.js
            echo "${row} y $y"
        done

        echo "]]" >> map.js
    fi
done

echo "];" >> map.js

echo "done all"
