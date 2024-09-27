#!/bin/bash

# Function to calculate the total duration of the playlist in seconds
calculate_playlist_duration() {
    playlist_path="$1"
    
    total_duration=0

    # Iterate over each file in the playlist and sum up the durations
    while IFS= read -r video_file; do
        if [ -f "$video_file" ]; then
            # Get video duration using ffprobe (from ffmpeg)
            video_duration=$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 "$video_file" 2>/dev/null)
            total_duration=$(echo "$total_duration + $video_duration" | bc)
        fi
    done < "$playlist_path"
    
    # Return total duration in seconds
    echo "$total_duration"
}

# Function to start VLC and calculate total duration for a given playlist
play_playlist() {
    playlist_name="$1"
    playlist_path="$2"

    echo "Starting DISPLAY=:0 vlc with playlist: $playlist_name"
    
    # Start VLC
    DISPLAY=:0 vlc --fullscreen --aspect 16:9 --no-video-title-show --random --play-and-exit "$playlist_path" &
    vlc_pid=$!

    # Calculate the total duration of the playlist
    total_duration=$(calculate_playlist_duration "$playlist_path")

    echo "Total duration of $playlist_name playlist: $total_duration seconds"

    # Sleep for the calculated duration
    sleep "$total_duration"s

    # Kill VLC if it's still running
    pkill vlc
}

# Playlist functions
off_air_playlist() { play_playlist "Off-Air" "/home/jenny/retro_tv/programming/Other/off_air.m3u"; }
morning_news_playlist() { play_playlist "Morning News" "/home/jenny/retro_tv/programming/News/morning_news.m3u"; }
evening_news_playlist() { play_playlist "Evening News" "/home/jenny/retro_tv/programming/News/evening_news.m3u"; }
infomercials_playlist() { play_playlist "Infomercials" "/home/jenny/retro_tv/programming/Other/infomercials.m3u"; }
snl_playlist() { play_playlist "SNL" "/home/jenny/retro_tv/programming/TV/snl.m3u"; }
game_shows_playlist() { play_playlist "Game Shows" "/home/jenny/retro_tv/programming/TV/game_shows.m3u"; }
soap_operas_playlist() { play_playlist "Soap Operas" "/home/jenny/retro_tv/programming/TV/soap_operas.m3u"; }
cartoons_playlist() { play_playlist "Cartoons" "/home/jenny/retro_tv/programming/TV/cartoons.m3u"; }
sports_playlist() { play_playlist "Sports" "/home/jenny/retro_tv/programming/Other/sports.m3u"; }
sitcoms_playlist() { play_playlist "Sitcoms" "/home/jenny/retro_tv/programming/TV/sitcoms.m3u"; }
saturday_night_playlist() { play_playlist "Saturday Night" "/home/jenny/retro_tv/programming/Movies/saturday_night.m3u"; }
talk_shows_playlist() { play_playlist "Talk Shows" "/home/jenny/retro_tv/programming/TV/talk_shows.m3u"; }
horror_night_playlist() { play_playlist "Horror Night" "/home/jenny/retro_tv/programming/Movies/horror_night.m3u"; }

# Main loop
while true; do
    current_day=$(date +'%a') # Mon, Tue, Wed, Thu, Fri, Sat, Sun
    current_hour=$(date +'%H')

    case "$current_day" in
        Mon|Tue|Wed|Thu|Fri)
            if [ "$current_hour" -ge 06 ] && [ "$current_hour" -lt 09 ]; then
                morning_news_playlist
            elif [ "$current_hour" -ge 09 ] && [ "$current_hour" -lt 12 ]; then
                game_shows_playlist
            elif [ "$current_hour" -ge 12 ] && [ "$current_hour" -lt 15 ]; then
                soap_operas_playlist
            elif [ "$current_hour" -ge 15 ] && [ "$current_hour" -lt 18 ]; then
                cartoons_playlist
            elif [ "$current_hour" -ge 18 ] && [ "$current_hour" -lt 20 ]; then
                evening_news_playlist
            elif [ "$current_hour" -ge 20 ] && [ "$current_hour" -lt 21 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 21 ] && [ "$current_hour" -lt 23 ]; then
                saturday_night_playlist
            elif [ "$current_hour" -ge 23 ] && [ "$current_hour" -lt 24 ]; then
                talk_shows_playlist
            elif [ "$current_hour" -ge 00 ] && [ "$current_hour" -lt 02 ]; then
                saturday_night_playlist
            elif [ "$current_hour" -ge 02 ] && [ "$current_hour" -lt 03 ]; then
                infomercials_playlist
            elif [ "$current_hour" -ge 03 ] && [ "$current_hour" -lt 05 ]; then
                horror_night_playlist
            elif [ "$current_hour" -ge 05 ] && [ "$current_hour" -lt 06 ]; then
                off_air_playlist
            fi
            ;;
        Sat)
            if [ "$current_hour" -ge 06 ] && [ "$current_hour" -lt 12 ]; then
                cartoons_playlist
            elif [ "$current_hour" -ge 12 ] && [ "$current_hour" -lt 15 ]; then
                sports_playlist
            elif [ "$current_hour" -ge 15 ] && [ "$current_hour" -lt 18 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 18 ] && [ "$current_hour" -lt 19 ]; then
                evening_news_playlist
            elif [ "$current_hour" -ge 19 ] && [ "$current_hour" -lt 20 ]; then
                game_shows_playlist
            elif [ "$current_hour" -ge 20 ] && [ "$current_hour" -lt 22 ]; then
                saturday_night_playlist
            elif [ "$current_hour" -ge 22 ] && [ "$current_hour" -lt 23 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 23 ] && [ "$current_hour" -lt 24 ]; then
                talk_shows_playlist
            elif [ "$current_hour" -ge 00 ] && [ "$current_hour" -lt 01 ]; then
                snl_playlist
            elif [ "$current_hour" -ge 01 ] && [ "$current_hour" -lt 02 ]; then
                infomercials_playlist
            elif [ "$current_hour" -ge 02 ] && [ "$current_hour" -lt 04 ]; then
                horror_night_playlist
            elif [ "$current_hour" -ge 04 ] && [ "$current_hour" -lt 05 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 05 ] && [ "$current_hour" -lt 06 ]; then
                off_air_playlist
            fi
            ;;
        Sun)
            if [ "$current_hour" -ge 06 ] && [ "$current_hour" -lt 09 ]; then
                morning_news_playlist
            elif [ "$current_hour" -ge 09 ] && [ "$current_hour" -ge 12 ]; then
                talk_shows_playlist
            elif [ "$current_hour" -ge 12 ] && [ "$current_hour" -lt 18 ]; then
                sports_playlist
            elif [ "$current_hour" -ge 18 ] && [ "$current_hour" -lt 19 ]; then
                evening_news_playlist
            elif [ "$current_hour" -ge 19 ] && [ "$current_hour" -lt 20 ]; then
                game_shows_playlist
            elif [ "$current_hour" -ge 20 ] && [ "$current_hour" -lt 22 ]; then
                saturday_night_playlist
            elif [ "$current_hour" -ge 22 ] && [ "$current_hour" -lt 23 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 23 ] && [ "$current_hour" -lt 24 ]; then
                talk_shows_playlist
            elif [ "$current_hour" -ge 00 ] && [ "$current_hour" -lt 02 ]; then
                horror_night_playlist
            elif [ "$current_hour" -ge 02 ] && [ "$current_hour" -lt 04 ]; then
                sitcoms_playlist
            elif [ "$current_hour" -ge 04 ] && [ "$current_hour" -lt 06 ]; then
                off_air_playlist
            fi
            ;;
    esac

    # Wait for 1 minute before checking the schedule again
    sleep 60
done
