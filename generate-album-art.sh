#!/bin/bash

# Generates album art from music file
imagename="folder.jpg"

# Supporting functions
function extract_if_present() {
    img="$1/$imagename"

    files=$(find "$1/" -name "*.$2" -maxdepth 1 2>/dev/null | wc -l)
    deep_files=$(find "$1/" -name "*.$2" 2>/dev/null | wc -l)

    if [ "$files" != 0 ]; then
        for i in "$1"/*."$2"; do 
            if [ ! -f "$img" ]; then
                ffmpeg -i "$i" -an -c:v copy "$img"; 
            fi
        done
        echo "$files"

    elif [ "$deep_files" != 0 ]; then
        files_extracted=0

        for subdir in "$1"/*/; do 
            if [[ ! "$subdir" == *"@eaDir"* ]]; then
                if [ ! -f "$subdir/$imagename" ]; then
                    new_files_extracted=$(extract_if_present "$subdir" "$2")
                    files_extracted=$new_files_extracted+$files_extracted
                fi
            fi
        done

        if [ "$files_extracted" = 0 ]; then
            echo "Nested directories of potentially imaged"
        else
            echo "$files_extracted nested"
        fi

    else
        echo 0
    fi
}


echo "Generating images for albums under $PWD"...
echo

currentpath=$PWD

for dir in "$currentpath"/*/
do
    dir=${dir%*/}
    img="$dir/$imagename"
    echo "Analysing folder '${dir##*/}'..."

    if [ -f "$img" ]; then
        echo "- Album image already exists in directory"

    else
        mp3s_extracted=$(extract_if_present "$dir" mp3)
        flacs_extracted=$(extract_if_present "$dir" flac)

        if [ ! "$mp3s_extracted" = 0 ]; then
            echo "- Image extract attempted by parsing $mp3s_extracted MP3 files"

        elif [ ! "$flacs_extracted" = 0 ]; then
            echo "- Image extract attempted by parsing $flacs_extracted FLAC files"

        else
            echo "- No music files to extract image from in directory"
        fi
    fi
    echo
done

echo
echo "Operation completed"
