#!/bin/bash

output_dir="./i18n/locales/generated"
files=("en-resume.yaml" "es-resume.yaml" "pt-resume.yaml")

mkdir -p "$output_dir"

for file in "${files[@]}"; do
  filepath="$output_dir/$file"
  if [ ! -f "$filepath" ]; then
    echo -e "resume:\n  html: |\n    <h1>Missing translation</h1><p><code>npm run build:resume</code><p>\n" > "$filepath"
    echo "Created empty file: $filepath"
  fi
done
