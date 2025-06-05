#!/bin/bash

# Set paths
SOURCE_DIR="location of recovered files (input)"
DEST_BASE="where to save (output)"
LOG_FILE="$DEST_BASE/recovery_log.txt"

# Create destination folders
mkdir -p "$DEST_BASE"/{Documents,Images,Keys,Databases,Music,Other}

echo "Recovery started at $(date)" > "$LOG_FILE"

# Define categories and patterns
declare -A categories=(
  ["Documents"]="*.pdf *.doc *.docx *.odt *.txt *.rtf *.xls *.xlsx *.ods *.ppt *.pptx *.odp"
  ["Images"]="*.jpg *.jpeg *.png *.bmp *.gif *.tiff *.webp *.svg"
  ["Keys"]="*.asc *.gpg *.pgp *.key *.pem *.crt *.cer"
  ["Databases"]="*.kdbx *.kdb *.sqlite *.db *.bak *.csv"
  ["Music"]="*.mp3 *.wav *.ogg *.flac *.aac *.m4a *.wma"
  ["Other"]="*.xml *.ini *.json *.log *.md"
)

# Search and copy files
for category in "${!categories[@]}"; do
  echo "Processing $category files..." | tee -a "$LOG_FILE"
  for pattern in ${categories[$category]}; do
    find "$SOURCE_DIR"/recup_dir.* -type f -iname "$pattern" -exec cp -n {} "$DEST_BASE/$category/" \; -exec echo "{}" >> "$LOG_FILE" \;
  done
done

# Count files per category
echo -e "\nFile counts:" >> "$LOG_FILE"
for category in "${!categories[@]}"; do
  count=$(find "$DEST_BASE/$category" -type f | wc -l)
  echo "$category: $count files" | tee -a "$LOG_FILE"
done

echo "Recovery complete at $(date)" | tee -a "$LOG_FILE"
