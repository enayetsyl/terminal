#!/bin/bash

# Check if the tmux session already exists and kill it
tmux has-session -t mysession 2>/dev/null
if [ $? -eq 0 ]; then
  tmux kill-session -t mysession
fi

# Start a new tmux session
tmux new-session -d -s mysession

# Start recording with ffmpeg inside the tmux session
tmux send-keys -t mysession "ffmpeg -video_size 1920x1080 -framerate 25 -f x11grab -i :99.0 output.mp4" C-m

# Wait a bit to ensure ffmpeg starts properly
sleep 5

# Run your commands in the same tmux session
tmux send-keys -t mysession "npm install express && npm install react && npm install mongodb" C-m

# Wait for the commands to complete
tmux send-keys -t mysession "echo 'Commands completed. Press Ctrl+C to stop recording.'" C-m

# Attach to the tmux session to monitor
tmux attach -t mysession
