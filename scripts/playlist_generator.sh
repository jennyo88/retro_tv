#!/bin/bash

# Base directories for different types of content
BASE_DIR_TV="/home/jenny/freenas/Media/m.tv/"
BASE_DIR_MOVIES="/home/jenny/freenas/Media/m.movie/"
BASE_DIR_NEWS="/home/jenny/freenas/Media/m.fillers/news/"
BASE_DIR_OTHER="/home/jenny/freenas/Media/m.fillers/"

# Playlist directory path
PLAYLIST_DIR="/home/jenny/retro-tv/programming"

# Function to escape spaces in file paths
escape_spaces() {
    echo "$1" | sed 's/ /%20/g'
}

# Function to display existing playlists and let the user choose
choose_playlist() {
    echo "Existing playlists:"
    playlists=($(ls "$PLAYLIST_DIR"/*.txt 2>/dev/null))
    if [ ${#playlists[@]} -eq 0 ]; then
        echo "No existing playlists found."
        return 1
    fi
    for i in "${!playlists[@]}"; do
        playlist_name=$(basename "${playlists[$i]}")
        echo "$((i + 1)): $playlist_name"
    done
    echo "$(( ${#playlists[@]} + 1 )): Create a new playlist"
    read -p "Enter the number corresponding to your choice: " choice
    if [[ $choice -ge 1 && $choice -le ${#playlists[@]} ]]; then
        selected_playlist="${playlists[$((choice - 1))]}"
        echo "Selected existing playlist: $(basename "$selected_playlist")"
    elif [ "$choice" -eq $(( ${#playlists[@]} + 1 )) ]; then
        read -p "Enter the new playlist name (e.g., 'cartoons.txt'): " new_playlist_name
        selected_playlist="${PLAYLIST_DIR}/${new_playlist_name}"
        echo "Creating new playlist: $new_playlist_name"
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi
}

# Prompt user to select content type
clear
echo "Select content type:"
echo "1: TV Shows"
echo "2: Movies"
echo "3: News"
echo "4: Infomercials or Off-Air"
read -p "Enter the number corresponding to the content type: " content_type

case $content_type in
    1)
        BASE_DIR=$BASE_DIR_TV
        ;;
    2)
        BASE_DIR=$BASE_DIR_MOVIES
        ;;
    3)
        BASE_DIR=$BASE_DIR_NEWS
        ;;
    4)
        BASE_DIR=$BASE_DIR_OTHER
        ;;
    *)
        echo "Invalid selection. Exiting."
        exit 1
        ;;
esac

# Choose or create playlist
choose_playlist
if [ -z "$selected_playlist" ]; then
    echo "No playlist selected. Exiting."
    exit 1
fi

# Escape spaces in playlist path
selected_playlist=$(escape_spaces "$selected_playlist")

# Clear existing playlist content if it already exists
if [ -f "$selected_playlist" ]; then
    > "$selected_playlist"
fi

while true; do
    # Prompt user for keyword search
    read -p "Enter keywords to filter folders (leave empty for no filter): " keyword

    # List folders in the selected base directory with keyword filtering
    echo "Available folders in $BASE_DIR:"
    IFS=$'\n'  # Set Internal Field Separator to newline for proper handling
    folders=($(find "$BASE_DIR" -mindepth 1 -maxdepth 1 -type d | grep -i "$keyword"))
    unset IFS  # Reset Internal Field Separator

    if [ ${#folders[@]} -eq 0 ]; then
        echo "No folders found matching the keyword(s)."
        continue
    fi

    for i in "${!folders[@]}"; do
        folder_name=$(basename "${folders[$i]}")
        echo "$((i + 1)): $folder_name"
    done

    # Prompt user to choose a folder
    read -p "Enter the number of the folder to add to the playlist (or 0 to skip): " choice
    if [ "$choice" -eq 0 ]; then
        break
    fi

    index=$((choice - 1))

    if [[ $index -ge 0 && $index -lt ${#folders[@]} ]]; then
        selected_folder="${folders[$index]}"
        echo "Selected folder: $(basename "$selected_folder")"

        # Append files from the selected folder to the playlist
        find "$selected_folder" -type f \( -name "*.mp4" -o -name "*.avi" -o -name "*.mkv" \) -print0 | while IFS= read -r -d '' file; do
            echo "$(escape_spaces "$file")" >> "$selected_playlist"
        done
        echo "Appended videos from $(basename "$selected_folder") to $selected_playlist"
    else
        echo "Invalid choice. Please try again."
    fi

    # Ask if the user wants to add more folders
    read -p "Do you want to add more folders? (yes/no): " add_more
    if [[ "$add_more" =~ ^[Nn]o$ ]]; then
        break
    fi
done

echo "Playlist update complete."
