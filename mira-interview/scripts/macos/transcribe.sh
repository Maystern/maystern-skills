#!/usr/bin/env bash
set -euo pipefail
usage() { echo "Usage: transcribe.sh --project-root DIR --audio FILE --case-name NAME [-- WHISPER_ARGS...]"; }
PROJECT_ROOT=""; AUDIO=""; CASE_NAME=""; EXTRA_ARGS=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --project-root) PROJECT_ROOT=${2:?}; shift 2 ;;
    --audio) AUDIO=${2:?}; shift 2 ;;
    --case-name) CASE_NAME=${2:?}; shift 2 ;;
    --) shift; EXTRA_ARGS=("$@"); break ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done
[ -n "$PROJECT_ROOT" ] && [ -n "$AUDIO" ] && [ -n "$CASE_NAME" ] || { usage >&2; exit 2; }
PROJECT_ROOT=$(cd "$PROJECT_ROOT" && pwd -P); [ -f "$AUDIO" ] || { echo "Audio file not found: $AUDIO" >&2; exit 1; }
case "$CASE_NAME" in ""|.|..|*/*|unknown|case-[0-9]*) echo "case-name must be a concise company-date-round path segment." >&2; exit 2 ;; esac
CASE_DIR="$PROJECT_ROOT/interview-artifacts/$CASE_NAME"; INPUTS_DIR="$CASE_DIR/inputs"
case "$AUDIO" in "$INPUTS_DIR"/*) ;; *) echo "Audio must be the archived copy inside $INPUTS_DIR" >&2; exit 1 ;; esac
CONFIG_FILE="$PROJECT_ROOT/.mira-interview/config.env"; [ -f "$CONFIG_FILE" ] || { echo "Missing configuration: $CONFIG_FILE" >&2; exit 1; }
# shellcheck disable=SC1090
. "$CONFIG_FILE"
: "${FFMPEG_BIN:?Missing FFMPEG_BIN}"; : "${WHISPER_BIN:?Missing WHISPER_BIN}"; : "${WHISPER_MODEL_NAME:?Missing WHISPER_MODEL_NAME}"; : "${WHISPER_MODEL:?Missing WHISPER_MODEL}"; : "${VAD_MODEL:?Missing VAD_MODEL}"
case "$WHISPER_MODEL_NAME" in ""|.|..|*[!A-Za-z0-9._-]*) echo "WHISPER_MODEL_NAME must be a safe path segment: $WHISPER_MODEL_NAME" >&2; exit 1 ;; esac
WHISPER_THREADS=${WHISPER_THREADS:-8}
TRANSCRIPTION_PROMPT=${TRANSCRIPTION_PROMPT:-"这是一场只有两位参与者的求职面试对话：一位面试官，一位候选人（面试者）。请按实际发言完整转录对话。"}
for required in "$FFMPEG_BIN" "$WHISPER_BIN" "$WHISPER_MODEL" "$VAD_MODEL"; do [ -e "$required" ] || { echo "Configured path not found: $required" >&2; exit 1; }; done
OUT_DIR="$CASE_DIR/transcription/$WHISPER_MODEL_NAME"; /bin/mkdir -p "$OUT_DIR"
WAV_FILE="$OUT_DIR/interview-16k-mono.wav"; OUTPUT_PREFIX="$OUT_DIR/interview"; TRANSCRIPT_MD="$OUT_DIR/interview-transcript.md"
for output in "$WAV_FILE" "$OUTPUT_PREFIX.txt" "$OUTPUT_PREFIX.srt" "$OUTPUT_PREFIX.json" "$TRANSCRIPT_MD"; do [ ! -e "$output" ] || { echo "Refusing to overwrite existing output: $output" >&2; exit 1; }; done
"$FFMPEG_BIN" -nostdin -hide_banner -loglevel warning -i "$AUDIO" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV_FILE"
set +u
"$WHISPER_BIN" -m "$WHISPER_MODEL" -f "$WAV_FILE" -l auto -t "$WHISPER_THREADS" --prompt "$TRANSCRIPTION_PROMPT" --carry-initial-prompt --vad -vm "$VAD_MODEL" -otxt -osrt -oj -of "$OUTPUT_PREFIX" "${EXTRA_ARGS[@]}"
set -u
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)
bash "$SCRIPT_DIR/format-transcript.sh" "$OUTPUT_PREFIX.srt" "$TRANSCRIPT_MD"
echo "Transcription ready: $OUT_DIR"
