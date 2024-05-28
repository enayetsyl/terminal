#!/bin/bash

# Start a new gnome-terminal
gnome-terminal &

# Wait a bit to ensure the terminal starts
sleep 3

# Get the window ID of the new terminal
new_window_id=$(xdotool search --onlyvisible --class gnome-terminal | tail -1)
echo "New window ID: $new_window_id"

# Focus the new terminal window
xdotool windowactivate $new_window_id

# Run two sample commands in the new terminal
xdotool windowfocus --sync $new_window_id
xdotool type  "echo 'Hello, World!'"
xdotool key Return
sleep 1
xdotool type  "ls -la"
xdotool key Return
