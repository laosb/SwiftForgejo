#!/bin/bash

set -e

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

# Check if git is available
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required but not installed. Please install git first."
    exit 1
fi

# Define paths
OPENAPI_JSON="Sources/ForgejoAPI/openapi.json"
CONFIG_FILE="Sources/ForgejoAPI/openapi-generator-config.yaml"
OUTPUT_DIR="Sources/ForgejoAPI"

# Verify input file exists
if [[ ! -f "$OPENAPI_JSON" ]]; then
    echo "Error: OpenAPI definition not found at $OPENAPI_JSON"
    exit 1
fi

# Verify config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Extract version from openapi.json
VERSION=$(jq -r '.info.version' "$OPENAPI_JSON")

if [[ -z "$VERSION" || "$VERSION" == "null" ]]; then
    echo "Error: Could not extract version from $OPENAPI_JSON"
    exit 1
fi

echo "Generating Swift client code for Forgejo API version $VERSION..."

# Generate Swift files using swift-openapi-generator CLI
swift run swift-openapi-generator generate \
    "$OPENAPI_JSON" \
    --config "$CONFIG_FILE" \
    --output-directory "$OUTPUT_DIR"

echo "Successfully generated Swift client code"

# Stage the generated Swift files
echo "Staging generated Swift source files..."
git add "$OUTPUT_DIR"/*.swift

# Check if there are changes to commit
if git diff --cached --quiet; then
    echo "No changes to commit - generated code is already up to date"
    exit 0
fi

# Commit the changes
COMMIT_MESSAGE="Generate Swift client for Forgejo API $VERSION"
echo "Committing changes with message: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

echo "Successfully committed generated code for version $VERSION"
