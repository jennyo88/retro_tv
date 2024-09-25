#!/bin/bash

# Set directories for different content categories
SCHEDULE_DIR="/home/jenny/retro_tv/schedules"
TV_DIR="/home/jenny/retro_tv/programming/TV"
MOVIES_DIR="/home/jenny/retro_tv/programming/Movies"
NEWS_DIR="/home/jenny/retro_tv/programming/News"
OTHER_DIR="/home/jenny/retro_tv/programming/Other"
PLAYLIST_DIR="/home/jenny/retro_tv/playlists"

# Array of days of the week
days=("monday" "tuesday" "wednesday" "thursday" "friday" "saturday" "sunday")

# Loop through each day and run the playlist generator script
for day in "${days[@]}"; do
    # Set the schedule file path based on the day
    schedule_file="${SCHEDULE_DIR}/${day}_schedule.txt"

    # Set the playlist file path
    playlist="${PLAYLIST_DIR}/playlist_${day}.m3u8"
    echo "#EXTM3U" > "$playlist"

    # Check if the schedule file exists
    if [ ! -f "$schedule_file" ]; then
        echo "Schedule file for $day not found: $schedule_file"
        continue
    fi

    # Read the schedule file and process each category
    while IFS=, read -r subcategory num_videos; do
        subcategory=$(echo $subcategory | xargs)  # Trim whitespace
        num_videos=$(echo $num_videos | xargs)  # Trim whitespace

        # Map the subcategory to the correct folder
        case $subcategory in
            "adventure"|"anthology"|"cartoons"|"crime"|"drama"|"family"|"game_shows"|"scifi"|"itcoms"|"snl"|"soap_operas"|"talk_shows")
                category_file="${TV_DIR}/${subcategory}.txt"
                ;;
            "family_night"|"saturday_night"|"horror_night")
                category_file="${MOVIES_DIR}/${subcategory}.txt"
                ;;
            "morning_news"|"evening_news"|"local_news")
                category_file="${NEWS_DIR}/${subcategory}.txt"
                ;;
            "infomercials"|"off_air"|"sports"|"variety")
                category_file="${OTHER_DIR}/${subcategory}.txt"
                ;;
            *)
                echo "Warning: Unknown subcategory '$subcategory' for day '$day'. Skipping."
                continue
                ;;
        esac

        # Check if the corresponding subcategory file exists
        if [ -f "$category_file" ]; then
            echo "# $subcategory" >> "$playlist"
            
            # Grab the specified number of random videos from the subcategory file
            count=0
            for video in $(shuf -n "$num_videos" "$category_file"); do
                echo "#EXTINF:-1,$subcategory" >> "$playlist"
                echo "$video" >> "$playlist"
                ((count++))
            done

            # Warning if not enough videos are available in the subcategory file
            if [ $count -lt "$num_videos" ]; then
                echo "Warning: Only $count videos available in $category_file for '$subcategory'."
            fi
        else
            echo "Warning: Subcategory file not found: $category_file"
        fi
    done < "$schedule_file"

    echo "M3U8 playlist created for $day: $playlist"
done
