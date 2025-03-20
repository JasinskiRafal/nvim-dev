#!/bin/bash

# Check if the user has provided an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <service_to_start>"
  exit 1
fi

docker compose run --rm "$1"
