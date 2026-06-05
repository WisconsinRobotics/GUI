#!/bin/bash

# Define a function to clean up background processes if the script is interrupted
function cleanup() {
    echo "Interrupt received. Killing background processes..."
    kill $(jobs -p)
    exit 1
}

# Trap Ctrl-C (INT signal) to run the cleanup function
trap cleanup INT


echo "Start streaming..."
(cd gstreamer && python3 gst-env.py && export GST_PLUGIN_PATH=/home/wiscrobo/workspace/gui/gst-plugins-rs/target/debug:$GST_PLUGIN_PATH && gst-launch-1.0 webrtcsink name=ws meta="meta,name=gst-stream" videotestsrc ! videoconvert ! vp8enc deadline=1 ! queue ! video/x-vp8 ! ws. ) &

PID1=$!

# Wait for all background jobs (specified by their PIDs)
wait $PID1

echo "All processes have finished."

