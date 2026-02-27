#!/usr/bin/env bash

set -euo pipefail

INPUT="public/_redirects"
OUTPUT="docker/nginx-redirections.conf"
TMP="$(mktemp)"

if [[ ! -f "$INPUT" ]]; then
  echo "Input file not found: $INPUT" >&2
  exit 1
fi

echo "# Auto-generated. Do not edit manually." > "$TMP"

while IFS= read -r line || [[ -n "$line" ]]; do
  # Trim leading/trailing whitespace
  line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

  # Skip empty lines and comments
  [[ -z "$line" ]] && continue
  [[ "$line" =~ ^# ]] && continue

  # Parse fields
  read -r from to status <<< "$line"

  if [[ -z "${from:-}" || -z "${to:-}" ]]; then
    echo "Invalid rule: $line" >&2
    exit 1
  fi

  # Default status code
  status="${status:-308}"

  # Basic status validation
  if [[ ! "$status" =~ ^30[1278]$ ]]; then
    echo "Invalid status code in line: $line" >&2
    exit 1
  fi

  # Generate exact match redirect
  printf "location = %s { return %s %s; }\n" "$from" "$status" "$to" >> "$TMP"

done < "$INPUT"

mv "$TMP" "$OUTPUT"

echo "Generated $OUTPUT"
