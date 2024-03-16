#!/bin/bash

KEYBOARD_ID=3
MOUSE_ID=2
LOG_FILE=~/input_log.txt

echo "Hello there, watch out!"

# Function to log keyboard activity
monitor_keyboard() {
  xinput test $KEYBOARD_ID >> $LOG_FILE &
}

# Function to log mouse activity
monitor_mouse() {
  xinput test $MOUSE_ID >> $LOG_FILE &
}

# Start monitoring
monitor_keyboard
monitor_mouse

echo "Press CTRL+C to abort mission."

# Keep the script running until manually stopped
wait

