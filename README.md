# Fix Filenames Script

This script renames files in the current directory to ensure they have clean, consistent, and cross-platform friendly filenames. It addresses common issues with special characters, extra dots, and unsupported symbols that can cause issues on certain filesystems.

## **Features**
- Removes or replaces problematic characters (like colons `:`, accents, and special symbols).
- Converts spaces (` `) to underscores (`_`) for better cross-platform compatibility.
- Preserves file extensions correctly (e.g., `.mp3` stays intact).
- Prevents the script itself (`fix_filenames.sh`) from being renamed.
- Ensures filenames contain only **letters, numbers, underscores (`_`), and hyphens (`-`)**.

---

## **Usage**
1. **Download the script** and place it in the directory containing the files you want to rename.
2. **Make the script executable** using the following command:
   ```bash
   chmod +x fix_filenames.sh
   ```
3. **Run the script** in the directory with the files you want to clean up:
   ```bash
   ./fix_filenames.sh
   ```
4. The script will rename all files in the current directory and print the changes to the console.

---

## **Example**
**Before Running the Script:**
```
01 J. Strauss II: Overture Die Fledermaus - arr. Winter.mp3
02 Elgar: Variations on an Original Theme, Op.36 "Enigma" - arr. Wright - Nimrod.mp3
17 Dvořák: 8 Slavonic Dances, Op.46 - Arr. D.Wright - 8. No.8 in G minor.mp3
fix_filenames.sh
```

**After Running the Script:**
```
01_J_Strauss_II-_Overture_Die_Fledermaus_-_arr_Winter.mp3
02_Elgar-_Variations_on_an_Original_Theme_Op36_Enigma_-_arr_Wright_-_Nimrod.mp3
17_Dvorak-_8_Slavonic_Dances_Op46_-_Arr_DWright_-_8_No8_in_G_minor.mp3
fix_filenames.sh (not renamed)
```

---

## **Script Walkthrough**

1. **Skip Renaming the Script**
   ```bash
   if [ "$file" == "fix_filenames.sh" ]; then
       continue
   fi
   ```
   The script checks if the file is itself (`fix_filenames.sh`) and skips it to avoid accidental renaming.

2. **Separate File Name and Extension**
   ```bash
   base="${file%.*}"
   extension="${file##*.}"
   ```
   This splits the filename into two parts: 
   - `base`: the part of the filename before the last dot.
   - `extension`: the part after the last dot (e.g., `mp3`, `txt`, `jpg`).

3. **Clean the Filename**
   ```bash
   newbase=$(echo "$base" | \
       sed 's/[:]/-/g' | \
       sed 'y/řáéíóúýčďěňšťů/raeiouycdentsu/' | \
       sed 's/ /_/g' | \
       sed 's/[^a-zA-Z0-9_-]//g' \
   )
   ```
   This part does several cleanup steps:
   - Replace colons (`:`) with dashes (`-`).
   - Convert accented characters (like `ř` to `r`, `á` to `a`, etc.) to plain ASCII characters.
   - Replace spaces (` `) with underscores (`_`).
   - Remove any characters that are **not letters, numbers, hyphens (`-`), or underscores (`_`)**.

4. **Remove Extra Dots from Filename (Not Extension)**
   ```bash
   newbase=$(echo "$newbase" | sed 's/\.//g')
   ```
   This removes any unnecessary dots from the base name.

5. **Recombine Filename and Extension**
   ```bash
   newfile="${newbase}.${extension}"
   ```
   The cleaned filename is then reassembled with its original extension.

6. **Rename the File**
   ```bash
   if [ "$file" != "$newfile" ]; then
       mv "$file" "$newfile"
       echo "Renamed: '$file' -> '$newfile'"
   fi
   ```
   If the new filename is different from the original, the file is renamed, and the change is printed to the console.

---

## **Full Script**
```bash
#!/bin/bash

for file in *; do
    # Skip renaming this script itself
    if [ "$file" == "fix_filenames.sh" ]; then
        continue
    fi

    # Separate the filename from its extension
    base="${file%.*}"
    extension="${file##*.}"

    # Clean up the base name
    newbase=$(echo "$base" | \
        sed 's/[:]/-/g' | \
        sed 'y/řáéíóúýčďěňšťů/raeiouycdentsu/' | \
        sed 's/ /_/g' | \
        sed 's/[^a-zA-Z0-9_-]//g' \
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
```

---

## **Limitations**
- The script assumes that the file extension is correct and does not validate it.
- It works only on files in the **current directory**.
- Files with identical cleaned filenames may overwrite each other (e.g., `file1.txt` and `file-1.txt` both becoming `file1.txt`).

---

## **License**
This script is open-source and licensed under the MIT License. You are free to use, modify, and distribute it as needed.

---

## **Contributing**
If you'd like to improve this script, feel free to open a pull request or issue on the GitHub repository.

---

If you have any questions or suggestions, feel free to open an issue or submit a pull request. Happy coding! 😎

