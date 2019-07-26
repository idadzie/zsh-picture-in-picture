# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"

# Then ${0:h} to get plugin's directory

setopt localoptions extendedglob

typeset -gAH ZPNP

: ${ZPNP[RESIZE_SLEEP_TIME]:=0.5}
: ${ZPNP[VIDEO_SCALE_DIMENSION]:=300}
: ${ZPNP[PORTRAIT_VIDEO_SCALE_DIMENSION]:=${ZPNP[VIDEO_SCALE_DIMENSION]}}
: ${ZPNP[LANDSCAPE_VIDEO_SCALE_DIMENSION]:=${ZPNP[VIDEO_SCALE_DIMENSION]}}

: ${ZPNP[OFFSET]:=40}
: ${ZPNP[X_AXIS_OFFSET]:=${ZPNP[OFFSET]}}
: ${ZPNP[Y_AXIS_OFFSET]:=${ZPNP[OFFSET]}}

declare -a display_info display_dimension
display_info=( ${(f)"$(command xdpyinfo)"} )
display_dimension=( ${(M)display_info:#(#i)*dimensions:*} )
display_dimension=( ${${(s: :)display_dimension}[2]} )
display_dimension=( ${(@s/x/)display_dimension} )

local display_width display_height
display_width=${display_dimension[1]}
display_height=${display_dimension[2]}

: ${ZPNP[PRIMARY_X_SPACE]:=$display_width}
: ${ZPNP[PRIMARY_Y_SPACE]:=$display_height}
: ${ZPNP[USABLE_X_SPACE]:=$(echo "scale=0; (${ZPNP[PRIMARY_X_SPACE]} - ${ZPNP[X_AXIS_OFFSET]})" | bc)}
: ${ZPNP[USABLE_Y_SPACE]:=$(echo "scale=0; (${ZPNP[PRIMARY_Y_SPACE]} - ${ZPNP[Y_AXIS_OFFSET]})" | bc)}
: ${ZPNP[TOGGLE_WINDOW_DECORATIONS]:=false}

_picture-in-picture() {
  [[ $# -eq 0 ]] && return

  local video_file="$1"

  # Get video dimension.
  declare -a video_dimension
  local video_width video_height
  video_dimension=$(command mediainfo --inform="Video;%Width%x%Height%" $video_file)
  video_dimension=( ${(@s/x/)video_dimension} )
  video_width=${video_dimension[1]}; video_height=${video_dimension[2]}

  # Open video file.
  vlc --qt-minimal-view --daemon --video-on-top --no-repeat --no-qt-name-in-title \
      --no-loop --qt-continue='0' --play-and-exit --no-video-title-show $video_file &> /dev/null

  # Introduce delay for xdotool to locate VLC window.
  sleep ${ZPNP[RESIZE_SLEEP_TIME]}

  # Compute dimensions for xdotool to resize VLC window.
  local mini_video_width mini_video_height
  if [[ $video_width -gt $video_height ]]; then
    # Orientation: landscape.
    mini_video_width=${ZPNP[LANDSCAPE_VIDEO_SCALE_DIMENSION]}
    mini_video_height=$(echo "scale=4; ($video_height * $mini_video_width)/$video_width" | bc)
  else
    # Orientation: portrait.
    mini_video_height=${ZPNP[PORTRAIT_VIDEO_SCALE_DIMENSION]}
    mini_video_width=$(echo "scale=4; ($video_width * $mini_video_height)/$video_height" | bc)
  fi

  # Locate active VLC window.
  local vlc_window_id
  vlc_window_id=$(xdotool search --onlyvisible --name 'VLC media')

  # Toggle window decorations.
  if ${ZPNP[TOGGLE_WINDOW_DECORATIONS]}; then
    (( $+commands[toggle-decorations] )) && toggle-decorations $vlc_window_id
  fi

  # Resize VLC window.
  xdotool windowsize $vlc_window_id $mini_video_width $mini_video_height

  # Compute video position.
  x_position=$(echo "scale=4; (${ZPNP[USABLE_X_SPACE]} - $mini_video_width)" | bc)
  y_position=$(echo "scale=4; (${ZPNP[USABLE_Y_SPACE]} - $mini_video_height)" | bc)

  # Move VLC window to desired location. Default: bottom-right of screen.
  xdotool windowmove $vlc_window_id $x_position $y_position
}

twind() {
  (( $+commands[toggle-decorations] )) && {
    toggle-decorations $(xdotool search --onlyvisible --name 'VLC media')
  }
}

picture-in-picture() {
  [[ $# -eq 0 ]] && return

  declare -a video_extensions
  video_extensions=(
    3g2 3gp amv asf avi drc f4p f4v flv
    gif gifv m2ts m2v m4p m4v mkv mov mp2
    mp4 mpe mpeg mpg mpv mts mxf ogg ogv
    qt rm rmvb roq svi ts vob webm wmv yuv
  )

  local video_file="$1"
  if [[ ${video_extensions[(ie)$video_file:e]} -le ${#video_extensions} ]]; then
    _picture-in-picture $video_file
  fi
}

alias pnp='picture-in-picture'
