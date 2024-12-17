#!/bin/bash

for file in *; do
    # Skip renaming this script itself
    if [ "$file" == "fix_filenames.sh" ]; then
        continue
    fi

    # Separate the filename from its extension
    base="${file%.*}"         # Everything before the last dot
    extension="${file##*.}"   # Everything after the last dot

    # Clean up the base name
    newbase=$(echo "$base" | 
        sed 's/[:]/-/g' |                    # Replace colon (:) with dash (-)
        sed 'y/řáéíóúýčďěňšťů/raeiouycdentsu/' | # Replace accented characters with plain ones
        sed 's/ /_/g' |                     # Replace spaces with underscores (_)
        sed 's/[^a-zA-Z0-9_-]//g'           # Remove any remaining non-standard characters (except dash and underscore)
    )

    # Remove extra dots from the filename (dots should not be in the base name)
    newbase=$(echo "$newbase" | sed 's/\.//g')

    # Combine the new base with the original extension
    newfile="${newbase}.${extension}"

    # Rename the file only if the new name is different
    if [ "$file" != "$newfile" ]; then
        mv "$file" "$newfile"
        echo "Renamed: '$file' -> '$newfile'"
    fi
done

