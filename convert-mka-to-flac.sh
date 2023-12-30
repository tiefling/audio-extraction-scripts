#!/bin/bash

# Converts all the mka files in a directory to flacs
mkdir output
for i in *.mka; do ffmpeg -i "$i" -codec:a flac "output/${i%.*}.flac"; done