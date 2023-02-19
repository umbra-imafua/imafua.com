#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

for i in ./export/*-B.txt; do
    name=`echo "$i" | cut -c10- | cut -d'.' -f1 | cut -d'-' -f1`
