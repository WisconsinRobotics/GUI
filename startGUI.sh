#!/bin/bash

# 1. FORCE THE SCRIPT TO MOVE INTO ITS OWN DIRECTORY FIRST
cd "$(dirname "$0")"

# Explicitly load NVM if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source ROS 2 (Change 'humble' to your exact ROS version if different)
if [ -f "/opt/ros/humble/setup.bash" ]; then
    source /opt/ros/humble/setup.bash
fi

# Define a function to clean up background processes if the script is interrupted
# function cleanup() {
#     echo "Interrupt received. Killing background processes..."
#     kill $(jobs -p)
#     exit 1
# }

# # Trap Ctrl-C (INT signal) to run the cleanup function
# trap cleanup INT


# echo "Starting Backend..."
# (cd backend && node index.js) &
# PID1=$!

# sleep 5

# echo "Starting ROSBridge..."
# (ros2 launch rosbridge_server rosbridge_websocket_launch.xml) &
# PID2=$!

# echo "Starting Frontend..."
# (cd frontend &&  npm run start) &
# PID3=$!
# # Wait for all background jobs (specified by their PIDs)
# wait $PID1 $PID2 $PID3

# echo "All processes have finished."

# Get the absolute path of the project folder
ROOT_DIR="$(pwd)"

echo "Launching application suite..."

# Opens Tab 1 for the Backend
gnome-terminal --tab --title="Backend" -- bash -c "cd '$ROOT_DIR/backend' && node index.js; exec bash"

# Small delay to let database/backend spin up
sleep 3

# Opens Tab 2 for ROSBridge
gnome-terminal --tab --title="ROSBridge" -- bash -c "if [ -f /opt/ros/humble/setup.bash ]; then source /opt/ros/humble/setup.bash; fi; ros2 launch rosbridge_server rosbridge_websocket_launch.xml; exec bash"

# Opens Tab 3 for Frontend (React can clear this tab all it wants!)
gnome-terminal --tab --title="Frontend" -- bash -c "cd '$ROOT_DIR/frontend' && npm run start; exec bash"

