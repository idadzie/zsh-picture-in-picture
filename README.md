# zsh-picture-in-picture

[![License: MIT][license icon]][license]

This plugin allows you to open a video with [VLC][vlc] simulating 'Picture-in-Picture' while you interact with other applications.



## How it works

* [xdpyinfo][xdpyinfo] to figure out the display dimensions
* [mediainfo][mediainfo] to figure out video dimensions
* [VLC][vlc] to open the video file
* [xdotool][xdotool] to resize & position the VLC window



## Installation

### Dependencies

Install Dependencies.
```zsh
sudo apt-get install mediainfo xdotool vlc
```



### [Zplugin][zplugin]

Amazing Zsh plugin manager with clean fpath, reports, completion management, turbo mode etc.

```zsh
zplugin ice wait'0' lucid
zplugin light idadzie/zsh-picture-in-picture
```



## Usage

```zsh
picture-in-picture VIDEO.mkv
```



### Settings

### Alias

`picture-in-picture` is aliased `pnp`.



### Customizing Paths

The following variables can be set to custom values using the `$ZPNP` hash.

```zsh
# Add to .zshrc
declare -A ZPNP

# Examples
ZPNP[PORTRAIT_VIDEO_SCALE_DIMENSION]=400
ZPNP[LANDSCAPE_VIDEO_SCALE_DIMENSION]=500
```

```zsh
# Max width/height of scaled down video window. Default: 300
ZPNP[VIDEO_SCALE_DIMENSION]

# Max height of scaled down portrait video window. Default: 300
ZPNP[PORTRAIT_VIDEO_SCALE_DIMENSION]

# Max width of scaled down landscape video window. Default: 300
ZPNP[LANDSCAPE_VIDEO_SCALE_DIMENSION]

# Minimum distance from the right & bottom edge of primary display. Default: 40
ZPNP[OFFSET]

# Minimum distance from the right edge of primary display. Default: 40
ZPNP[X_AXIS_OFFSET]

# Minimum distance from the bottom edge of primary display.  Default: 40
ZPNP[Y_AXIS_OFFSET] 

# X axis dimension of primary display. Defaults to 1920 for a 1080p display.
ZPNP[PRIMARY_X_SPACE]  

# Y axis dimension of primary display. Defaults to 1080 for a 1080p display.
ZPNP[PRIMARY_Y_SPACE]

# Allowed X axis dimension within which a scaled down video window can be positioned.
# Defaults to 1880 since the default offset is 40.
ZPNP[USABLE_X_SPACE]

# Allowed Y axis dimension within which a scaled down video window can be positioned.
# Defaults to 1040 since the default offset is 40.
ZPNP[USABLE_Y_SPACE]  

# Delay time (in seconds) for xdotool to find opened VLC window. Default: 0.5
ZPNP[RESIZE_SLEEP_TIME] 
```



## License

The MIT License (MIT)

Copyright (c) 2019 idadzie

[license icon]: https://img.shields.io/badge/License-MIT-green.svg
[license]: https://opensource.org/licenses/MIT
[zplugin]: https://github.com/zdharma/zplugin
[xdpyinfo]: http://manpages.ubuntu.com/manpages/trusty/man1/xdpyinfo.1.html
[mediainfo]: https://mediaarea.net/en/MediaInfo
[vlc]: https://www.videolan.org/
[xdotool]: https://github.com/jordansissel/xdotool
