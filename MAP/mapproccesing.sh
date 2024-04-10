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

        read -r width height <<< $( identify -format "%w %h" export/${name}-C.jpg)

        if ($first); then 
            first=false
        else
            echo "," >> map.js
        fi

        exitstring=""
        artliststring=""
        filename="export/${name}.txt"
        n=0
        while read line; do
            if [[ n -lt 4  ]]; then
                if [[ "${line}" == "null"  ]]; then
                    exitstring="${exitstring}null"
                else
                    exitstring="${exitstring}\"${line}\""
                fi

                if [[ n -lt 3  ]]; then 
                    exitstring="${exitstring},"
                else 
                    echo "[\"$name\",$width,$height,[${exitstring}],[" >> map.js
                fi
            else
                artlistarray=(${line})
                if [ "$artlistarray[0]" == "" ]; then echo "blank line"
                elif [ "$artlistarray[1]" == "" ] || [ "${artlistarray[2]}" == "" ]; then echo "$artlistarray[0] has no location set"
                else
                    if ! [ "$artliststring" == "" ]; then
                        echo "," >> map.js
                    fi
                    artliststring="["
                    for i in "${!artlistarray[@]}"; do
                        if ! [[ "$i" = "0" ]]; then
                            artliststring="${artliststring},"
                        fi

                        if [[ ${artlistarray[i]} =~ ^[0-9]+$ ]]; then
                            artliststring="${artliststring}${artlistarray[i]}"
                        else
                            artliststring="${artliststring}\"${artlistarray[i]}\""
                        fi
                    done
                    artliststring="${artliststring}]"

                    echo -n "${artliststring}" >> map.js
                fi
            fi
            echo "Line No. $n : $line"
        n=$((n+1))
        done < $filename
        echo "" >> map.js
        echo "],[" >> map.js

        tilemap=""
        for ((y=32; y<=width; y+=64)) do

            row="\""
            for ((x=32; x<=width; x+=64)) do

                read -r hex <<< $( identify  -format "#%[hex:u.p{${x},${y}]" export/${name}-C.jpg)
                if [ "$hex" = "#FFFFFF" ]; then
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
