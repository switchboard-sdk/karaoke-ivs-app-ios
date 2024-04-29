#!/bin/bash

set -eu

# Determine the top-level directory of the git repository
PROJECT_DIR="$(git rev-parse --show-toplevel)"
SCRIPTS_DIR="$PROJECT_DIR/scripts"

# Define the source URL and the destination directory
AMAZONIVS_LIB_DIR_SRC="https://broadcast.live-video.net/1.13.4/AmazonIVSBroadcast-Stages.xcframework.zip"
AMAZONIVS_LIB_DIR_DST="${PROJECT_DIR}/libs"

# Remove the destination directory if it exists
rm -rf "${AMAZONIVS_LIB_DIR_DST}"

# Create the destination directory
mkdir -p "${AMAZONIVS_LIB_DIR_DST}"

# Download the file to the destination directory
curl -L "${AMAZONIVS_LIB_DIR_SRC}" -o "${AMAZONIVS_LIB_DIR_DST}/AmazonIVSBroadcast-Stages.xcframework.zip"

# Unzip the downloaded file
unzip -q "${AMAZONIVS_LIB_DIR_DST}/AmazonIVSBroadcast-Stages.xcframework.zip" -d "${AMAZONIVS_LIB_DIR_DST}"

# Optionally, remove the zip file after extraction if not needed
rm "${AMAZONIVS_LIB_DIR_DST}/AmazonIVSBroadcast-Stages.xcframework.zip"

echo "Download and extraction complete."
