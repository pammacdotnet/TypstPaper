#!/bin/sh

roman_numeral() {
  set -eu
  case "$1" in
    ''|*[!0-9]*)
      echo "Error: Input must be a number" >&2
      return 1
      ;;
  esac

  if [ "$1" -lt 1 ] || [ "$1" -gt 49 ]; then
    echo "Error: Input must be between 1 and 49" >&2
    return 1
  fi

  number=$1
  roman=""

  while [ "$number" -ge 40 ]; do
    roman="${roman}XL"
    number=$((number - 40))
  done

  while [ "$number" -ge 10 ]; do
    roman="${roman}X"
    number=$((number - 10))
  done

  if [ "$number" -eq 9 ]; then
    roman="${roman}IX"
    number=0
  fi

  while [ "$number" -ge 5 ]; do
    roman="${roman}V"
    number=$((number - 5))
  done

  if [ "$number" -eq 4 ]; then
    roman="${roman}IV"
    number=0
  fi

  while [ "$number" -ge 1 ]; do
    roman="${roman}I"
    number=$((number - 1))
  done

  echo "$roman"
}

if [ -z "$1" ]; then
  echo "Expecting plain text file" >&2
  exit 1
fi

i=1
missing=false
while true; do
  if ! count=$(grep -ciE "Fig\\. $i([^0-9]|$)" paper.txt); then
    break
  elif [ "$count" -lt 2 ]; then
    echo Missing reference to Figure "$i"
    missing=true
  fi
  i=$((i + 1))
done

i=1
while true; do
  if ! number=$(roman_numeral "$i"); then
    exit 1
  fi
  if ! count=$(grep -ciE "Table $number([^a-z]|$)" paper.txt); then
    break
  elif [ "$count" -lt 2 ]; then
    echo Missing reference to Table "$number"
    missing=true
  fi
  i=$((i + 1))
done

[ "$missing" != "true" ]
