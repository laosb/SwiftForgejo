#!/bin/bash

set -e

# Check if source URL argument is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <source-url>"
    echo "Example: $0 https://codeberg.org/swagger.v1.json"
    exit 1
fi

SOURCE_URL="$1"

# Check if we're in the package root directory
if [[ ! -f "Package.swift" || ! -d "Sources" ]]; then
    echo "Error: This script must be run from the package root directory (where Package.swift and Sources/ exist)"
    exit 1
fi

# Check if jq is available
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is required but not installed. Please install jq first."
    exit 1
fi

echo "Downloading OpenAPI definition from Forgejo..."

# Source URL to convert (provided as argument)
echo "Converting OpenAPI definition from: $SOURCE_URL"

# URL encode the source URL for the API call
ENCODED_URL=$(printf '%s' "$SOURCE_URL" | sed 's/:/%3A/g; s/\//%2F/g; s/\./%2E/g')

# URL to download from
API_URL="https://converter.swagger.io/api/convert?url=$ENCODED_URL"

# Output file
OUTPUT_FILE="Sources/ForgejoAPI/openapi.json"

# Create a temporary file for the raw download
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

# Download the OpenAPI document
if command -v curl >/dev/null 2>&1; then
    curl -s "$API_URL" -o "$TEMP_FILE"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$API_URL" -O "$TEMP_FILE"
else
    echo "Error: Neither curl nor wget is available. Please install one of them."
    exit 1
fi

# Verify the download was successful
if [[ ! -f "$TEMP_FILE" ]]; then
    echo "Error: Failed to download OpenAPI definition"
    exit 1
fi

# Pretty print JSON with jq and save to final location
if ! jq . "$TEMP_FILE" > "$OUTPUT_FILE"; then
    echo "Error: Downloaded content is not valid JSON"
    exit 1
fi

echo "Successfully downloaded and formatted OpenAPI definition to $OUTPUT_FILE"
