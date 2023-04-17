#!/bin/bash
# associative arrays of app variables
declare -A dotnetLegacy=(
    [version]="1.0.0"
    [nodeVersion]="19.8.1"
    [name]="dotnet-legacy"
)

declare -A globalQuote=(
    [version]="1.0.1"
    [nodeVersion]="14.16.1"
    [name]="global-quote-build"
)

# target app that you want built, set through env variable
TARGET="${TARGET:-"globalQuote"}"

# declare named variable TARGET_APP
declare -n TARGET_APP=$TARGET
IMAGE_NAME="inforitnl/${TARGET_APP[name]}"

docker build -t "$IMAGE_NAME" --build-arg NODEVERSION="${TARGET_APP[nodeVersion]}" .
docker tag "$IMAGE_NAME:latest" "$IMAGE_NAME:${TARGET_APP[version]}"

# docker tag
unset -n TARGET_APP
unset globalQuote
