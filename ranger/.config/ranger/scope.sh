#!/usr/bin/env bash
set -euo pipefail
path="$1"
width="${2:-80}"
height="${3:-40}"

case "$(file --mime-type -Lb "$path")" in
  text/*|*/json|*/xml|*/javascript)
    bat --color=always --style=numbers --line-range=:200 "$path" && exit 0 ;;
  image/*)
    identify "$path" && exit 0 ;;
  application/pdf)
    pdftotext -l 5 "$path" - && exit 0 ;;
  application/zip|application/x-tar|application/gzip|application/x-bzip2|application/x-xz)
    atool --list -- "$path" && exit 0 ;;
esac

highlight --out-format=ansi "$path" 2>/dev/null | head -200 && exit 0
file --brief "$path"
