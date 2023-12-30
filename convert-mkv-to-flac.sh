#!/bin/bash

rm -rf output
mkdir output

# Create mka files from the mkvs
for i in *.mkv; do mkvmerge --priority lower --output "${i%.*}.mka" --no-video --language 1:en --track-name 1:Stereo '(' "$i" ')' --split chapters:all; done

# Converts all the mka files in a directory to flacs
for i in *.mka; do ffmpeg -i "$i" -codec:a flac "output/${i%.*}.flac"; done

# Cleans up temp mka files
rm -f ./*.mka