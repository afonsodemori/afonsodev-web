#!/bin/bash

html_urls=(
  "https://static.afonso.dev/afonso-de-mori-cv-en.html"
  "https://static.afonso.dev/afonso-de-mori-cv-es.html"
  "https://static.afonso.dev/afonso-de-mori-cv-pt.html"
)

for html_url in "${html_urls[@]}"; do
  filename=$(basename $html_url)
  html_local_path=/tmp/$filename

  [[ $html_url =~ afonso-de-mori-cv-([a-z]{2})\.html ]] && lang="${BASH_REMATCH[1]}"
  output_yaml="./i18n/locales/generated/$lang-resume.yaml"

  curl $html_url -so $html_local_path
  sed -i '/<script/,/<\/script>/d' "$html_local_path"

  echo "Generate $output_yaml"
  {
    echo "resume:"
    echo "  html: |"
    sed "s/@/{'@'}/g; s/|/{'|'}/g; s/^/    /" "$html_local_path" # Replace @, | and indent lines
  } >$output_yaml

  rm $html_local_path
done
