#!/usr/bin/env bash
set -euo pipefail
[ "$#" -eq 2 ] || { echo "Usage: format-transcript.sh INPUT.srt OUTPUT.md" >&2; exit 2; }
INPUT=$1; OUTPUT=$2
[ -f "$INPUT" ] || { echo "SRT not found: $INPUT" >&2; exit 1; }
[ ! -e "$OUTPUT" ] || { echo "Refusing to overwrite: $OUTPUT" >&2; exit 1; }
{
  echo "# 面试完整逐字稿"; echo
  echo "> 说明：以下内容完整保留自动转录的全部非空片段和时间戳；说话人身份需结合上下文确认。"; echo
  awk '
    /^[0-9]+$/ { next }
    /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9],[0-9][0-9][0-9] --> / { if (text != "") { print "**[" time "] 说话人未标注：** " text "\n" }; time=$0; text=""; next }
    NF == 0 { if (text != "") { print "**[" time "] 说话人未标注：** " text "\n"; text=""; time="" }; next }
    { text = (text == "" ? $0 : text " " $0) }
    END { if (text != "") print "**[" time "] 说话人未标注：** " text "\n" }
  ' "$INPUT"
} > "$OUTPUT"
