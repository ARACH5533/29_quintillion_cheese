#!/usr/bin/env bash
set -e

MY_DIR="$(realpath "$(dirname $0)")"
. "$MY_DIR/config.sh"

check_vars=(IMG_DIR OUT BG_COLOR WIDTH HEIGHT FONTSIZE OFFSET CRF DUR FPS)
for var in "${check_vars[@]}"; do
    if [[ -z "${!var}" ]]; then echo "$var is not set in config.sh"; exit 1; fi
done

if ! declare -f get_video_title &>/dev/null; then echo "get_video_title() missing"; exit 1; fi
if ! declare -f get_ranking_title &>/dev/null; then echo "get_ranking_title() missing"; exit 1; fi

FILES=($(ls -v "$MY_DIR/$IMG_DIR"))
COUNT=${#FILES[@]}
if [ $COUNT -eq 0 ]; then echo "No image found"; exit 1; fi

FILTER_SCRIPT=$(mktemp)
trap "rm -f '$FILTER_SCRIPT'" EXIT

## ffmpeg ##
INPUT_ARGS=()
PADS=""
IDX=0

escape_filter_text() {
    local text=$1
    # 1. \ escape
    text="${text//\\/\\\\\\\\}"
    # 2. ' escape for ffmpeg
    text="${text//\'/\\\'}"
    # 3. : escape
    text="${text//:/\\:}"
    echo "$text"
}

## frame 1 ##: Video Title
INPUT_ARGS+=("-f" "lavfi" "-i" "color=c=${BG_COLOR}:s=${WIDTH}x${HEIGHT}:d=${DUR}")
title_text=$(escape_filter_text "$(get_video_title $(echo "$COUNT + $OFFSET" | bc))")
echo "[$IDX]drawtext=text='$title_text':fontcolor=white:fontsize=${FONTSIZE}:x=(w-text_w)/2:y=(h-text_h)/2,setsar=1[v$IDX];" >> "$FILTER_SCRIPT"
PADS+="[v$IDX]"
IDX=$((IDX + 1))

## frame 2+ ##
for (( i=$COUNT; i>=1; i-- )); do
    ##: Ranking Title
    INPUT_ARGS+=("-f" "lavfi" "-i" "color=c=${BG_COLOR}:s=${WIDTH}x${HEIGHT}:d=${DUR}")
    rank_text=$(escape_filter_text "$(get_ranking_title $(echo "$i + $OFFSET" | bc))")
    echo "[$IDX]drawtext=text='$rank_text':fontcolor=white:fontsize=${FONTSIZE}:x=(w-text_w)/2:y=(h-text_h)/2,setsar=1[v$IDX];" >> "$FILTER_SCRIPT"
    PADS+="[v$IDX]"
    IDX=$((IDX + 1))

    ##: Image
    img=${FILES[$((i - 1))]}
    INPUT_ARGS+=("-loop" "1" "-t" "${DUR}" "-i" "$MY_DIR/$IMG_DIR/$img")
    echo "[$IDX]scale=${WIDTH}:${HEIGHT}:force_original_aspect_ratio=decrease,pad=${WIDTH}:${HEIGHT}:(ow-iw)/2:(oh-ih)/2:black,setsar=1[v$IDX];" >> "$FILTER_SCRIPT"
    PADS+="[v$IDX]"
    IDX=$((IDX + 1))
done

# add concat
echo "${PADS}concat=n=$IDX:v=1:a=0[v]" >> "$FILTER_SCRIPT"

## generate video ##

ffmpeg -y "${INPUT_ARGS[@]}" \
    -filter_complex_script "$FILTER_SCRIPT" \
    -map '[v]' \
    -c:v libx264 \
    -bf 0 \
    -tune zerolatency \
    -use_editlist 0 \
    -profile:v main \
    -level 3.0 \
    -pix_fmt yuv420p \
    -r "$FPS" \
    -video_track_timescale 200000 \
    -bitexact \
    -crf "$CRF" \
    -preset veryfast \
    "$MY_DIR/_cache_.mp4"

ffmpeg -i "$MY_DIR/_cache_.mp4" -c copy -map_metadata -1 -movflags +faststart "$MY_DIR/$OUT"
rm "$MY_DIR/_cache_.mp4"

echo "Done: $MY_DIR/$OUT"
