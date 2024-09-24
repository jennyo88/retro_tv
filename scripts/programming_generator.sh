#!/bin/bash

# Set directories
SCHEDULE_DIR="/home/jenny/retro-tv/schedules"
PROGRAMMING_DIR="/home/jenny/retro-tv/programming"
PLAYLIST_DIR="/home/jenny/retro-tv/playlists"

# Ask for the day of the week
echo "Which day are you working on? (monday/tuesday/wednesday/thursday/friday/saturday/sunday): "
read day

# Convert to lowercase to ensure compatibility
day=$(echo "$day" | tr '[:upper:]' '[:lower:]')

# Set the schedule file path based on the day
schedule_file="${SCHEDULE_DIR}/${day}_schedule.txt"

# Set the playlist file path
playlist="${PLAYLIST_DIR}/playlist_${day}.m3u8"
echo "#EXTM3U" > $playlist

# Check if the schedule file exists
if [ ! -f "$schedule_file" ]; then
    echo "Schedule file for $day not found: $schedule_file"
    exit 1
fi

# Read the schedule file and process each category
while IFS=, read -r category num_videos; do
    category=$(echo $category | xargs)  # trim whitespace
    num_videos=$(echo $num_videos | xargs)  # trim whitespace

    # Set the category text file path
    category_file="${PROGRAMMING_DIR}/${category}.txt"

    # Check if the corresponding category text file exists
    if [ -f "$category_file" ]; then
        echo "# $category" >> $playlist
        
        # Grab the specified number of random videos from the category
        count=0

        # Use 'shuf' to shuffle the lines and get the first N videos
        for video in $(shuf -n $num_videos "$category_file"); do
            echo "#EXTINF:-1,$category" >> $playlist
            echo "$video" >> $playlist
            ((count++))
        done

        # Warning if not enough videos are available in the category file
        if [ $count -lt $num_videos ]; then
            echo "Warning: Only $count videos available in $category_file."
        fi
    else
        echo "Warning: Category file not found for $category."
    fi
done < "$schedule_file"

echo "M3U8 playlist created: $playlist"
