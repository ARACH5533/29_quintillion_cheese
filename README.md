# 29 Quintillion Cheese Maker 🧀

Create absurdly long-duration videos like the famous "top 29 quintillion cheese" meme by manipulating MP4 metadata.

## What does this do?

This project creates videos that appear to be impossibly long (e.g., 68 years, billions of years) by:
1. Generating a video with numbered cheese images
2. Modifying the MP4 file's `timescale` and `duration` metadata to trick video players into displaying an astronomical runtime

The actual video is only a few seconds long, but players will show it as years or even eons! 🚀

## Preview
```
Top 29,000,000,000,000,000,000 Cheese
#28,999,999,999,999,999,900 - [cheese image]
Duration: 68 years (but actually 1 minute)
```

## Requirements

- **git**
- **bash**
- **ffmpeg**
- **bc**
- **python3**

### NixOS
```bash
# Add `pkgs.git` to `environment.systemPackages`

git clone https://github.com/ARACH5533/29_quintillion_cheese.git
cd 29_quintillion_cheese
nix develop
```

### Other Linux / WSL

Install dependencies with your package manager:
```bash
# Debian/Ubuntu
sudo apt install git ffmpeg bc python3

# Arch
sudo pacman -S git ffmpeg bc python

# Git clone
git clone https://github.com/ARACH5533/29_quintillion_cheese.git
cd 29_quintillion_cheese
```

## Quick Start

1. **Add cheese images** to `video_creater/cheeses/` directory (any image format)

2. **Configure** (optional): Edit `video_creater/config.sh`

3. **Create video**:
```bash
cd video_creater
./create_cheeses.sh
```

4. **Fake the duration**:
```bash
mv top_cheese.mp4 ../duration_faker/input.mp4
cd ../duration_faker
./run.sh
```

5. **Done!** Your video is now `duration_faker/output.mp4` with astronomical duration 🎉

## Configuration

Edit `video_creater/config.sh` to customize:

| Variable | Default | Description |
|----------|---------|-------------|
| `CHEESES` | `100` | The number of cheese images |
| `OUT` | `top_cheese.mp4` | Output video filename |
| `BG_COLOR` | `blue` | Background color for title screen |
| `WIDTH` | `256` | Video width (pixels) |
| `HEIGHT` | `256` | Video height (pixels) |
| `FONTSIZE` | `15` | Font size for ranking text |
| `OFFSET` | `29*10^18 - 100` | Starting number (e.g., if you have 100 images but want "top 29 quintillion") |
| `CRF` | `40` | Video quality (0-51, lower = better quality) |
| `DUR` | `2` | Frame duration in seconds |
| `FPS` | `0.5` | Frames per second |

### Custom Title Functions
```bash
# Customize how titles appear
get_video_title() {
    echo "Top $1 Cheese"
}

get_ranking_title() {
    echo "#$1"
}

get_image_path() {
    echo "./cheeses/$1.png"
}
```
## Credits

- Inspired by the "top 29 quintillion cheese" discord meme.
