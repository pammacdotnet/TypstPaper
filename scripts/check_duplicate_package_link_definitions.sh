#!/bin/sh
set -eu

if [ -z "$*" ]; then
  echo "Expecting list of files to check" >&2
  exit 1
fi

definitions=$(grep -E '= +package-link' "$@")
count=$(echo "$definitions" | wc -l)
unique_count=$(echo "$definitions" | sort | uniq | wc -l)

if [ "$count" != "$unique_count" ]; then
  echo "Next package link definitions are duplicated:" >&2
  echo "$definitions" | sort | uniq --repeated >&2
  exit 1
fi
