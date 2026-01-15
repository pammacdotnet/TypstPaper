#!/bin/sh
set -eu

if [ -z "$*" ]; then
  echo "Expecting list of files to check" >&2
  exit 1
fi

definitions=$(grep -E '#let +[a-zA-Z-]+ += +package-link' "$@")
packages=$(echo "$definitions" | awk '{print $2}')

unused=false
while read -r package; do
  hash_count=$(grep -c "#$package" "$@" | cat)
  count=$(($(grep -cE "(^|[^#(])$package([^\")a-zA-Z-]|$)" "$@") - 1))
  if [ "$hash_count" -eq 0 ] && [ "$count" -eq 0 ]; then
    if [ "$unused" != "true" ]; then
      echo "Next package links are unused:" >&2
    fi
    unused=true
    printf "$package: #%s, %s\n" "$hash_count" "$count" >&2
  fi
done <<EOF
$packages
EOF

[ "$unused" != "true" ]
