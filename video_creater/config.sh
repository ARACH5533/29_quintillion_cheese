# stable config
CHEESES=100
OUT="top_cheese.mp4"
BG_COLOR="blue"
WIDTH=256
HEIGHT=256
FONTSIZE=15
OFFSET=$(echo "29*1000000000000000000 - 100" | bc)
CRF=40


get_video_title(){ # $1: (the number of cheeses) + $OFFSET
  #echo "top $1 cheeses"
  echo "top 29 quintillion cheeses"
}

MY_DIR="$(realpath "$(dirname $0)")"
get_image_path(){ # $1: the number of remaining cheeses
  echo "$MY_DIR/cheeses/$1.png"
}

get_ranking_title(){ # $1: (the number of remaining cheeses) + $OFFSET
  echo "top $1"
}

# unstable config
DUR=2
FPS=0.5
