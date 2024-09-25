#!/bin/bash

# Get current hour in 24-hour format (00-23) and current day of the week (1=Monday, 7=Sunday)
current_hour=$(date +"%H")
current_day=$(date +"%u")

# Only execute the script at 6 AM
if [ "$current_hour" -ne 6 ]; then
  echo "It's not 6 AM, no routines to run."
  exit 0
fi

# Define Monday routine
monday_routine() {
  echo "Monday 6 AM: Start your week strong!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_monday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Monday tasks
}

# Define Tuesday routine
tuesday_routine() {
  echo "Tuesday 6 AM: Stay focused and keep moving forward!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_tuesday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Tuesday tasks
}

# Define Wednesday routine
wednesday_routine() {
  echo "Wednesday 6 AM: Midweek, time to reflect and recharge!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_wednesday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Wednesday tasks
}

# Define Thursday routine
thursday_routine() {
  echo "Thursday 6 AM: Almost there, keep pushing!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_thursday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Thursday tasks
}

# Define Friday routine
friday_routine() {
  echo "Friday 6 AM: Finish strong, weekend is near!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_friday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Friday tasks
}

# Define Saturday routine
saturday_routine() {
  echo "Saturday 6 AM: Relax and enjoy your weekend!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_saturday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Saturday tasks
}

# Define Sunday routine
sunday_routine() {
  echo "Sunday 6 AM: Prepare for the upcoming week!"
  DISPLAY=:0 vlc --fullscreen --aspect-ratio 16:9 /home/jenny/retro_tv/playlists/playlist_sunday.m3u8 &
  sleep 24h
  pkill -f vlc
  exit 0
  # Add Sunday tasks
}

# Execute the appropriate routine based on the day of the week
case $current_day in
  1) monday_routine ;;
  2) tuesday_routine ;;
  3) wednesday_routine ;;
  4) thursday_routine ;;
  5) friday_routine ;;
  6) saturday_routine ;;
  7) sunday_routine ;;
  *) echo "Error: Invalid day of the week." ;;
esac
