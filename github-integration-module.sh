#!/bin/bash

################################
# Author: Gwhiz
# Version: v1_pro
#
# This script will serves as a foundation for interacting with the GitHub REST API and help users to communicate and retrieve information from GitHub

# Usage:
#   Please provide your GitHub token and the GitHub username or organization name as input
#
################################

if [ ${#@} -lt 2 ]; then
    echo "usage: $0 [your github token] [GitHub username or organization name]"
    exit 1
fi

GITHUB_TOKEN=$1
GITHUB_USERNAME=$2

GITHUB_API_HEADER_ACCEPT="Accept: application/vnd.github.v3+json"

temp=$(basename "$0")
TMPFILE=$(mktemp "/tmp/${temp}.XXXXXX") || exit 1

function rest_call {
    curl -s "$1" -H "${GITHUB_API_HEADER_ACCEPT}" -H "Authorization: token $GITHUB_TOKEN" >> "$TMPFILE"
}

# API endpoint to list repositories for a user or organization
API_ENDPOINT="/users/$GITHUB_USERNAME/repos"

# Make the API request
rest_call "https://api.github.com$API_ENDPOINT"

# Extract repository information, including ID, name, and created_at timestamp, in JSON format
jq -r '[.[] | {id, name, created_at}]' "$TMPFILE"

# Clean up the temporary file
rm -f "$TMPFILE"
