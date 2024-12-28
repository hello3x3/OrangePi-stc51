#!/bin/bash

RED='\033[0;31m'
GREEN='\033[32m'
NC='\033[0m'

TEMP=$(getopt -o o -- "$@")

if [ $? != 0 ]; then
    echo -e "${RED}[Error]${NC} Invalid parsing arguments."
    exit 1
fi

eval set -- "$TEMP"

ONLY_COMPILE=false
FILE=""

while true; do
    case "$1" in
        -o)
            ONLY_COMPILE=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo -e "${RED}[Error]${NC} Unexpected option: $1"
            exit 1
            ;;
    esac
done

if [ -z "$1" ]; then
    echo -e "${RED}[Error]${NC} An input file must be specified!"
    exit 1
fi

FILE="$1"
OUTPUT="${FILE%.c}.ihx"
DIRECTORY=$(dirname "$FILE")
SUCCESS_COMPILE=flase
SUCCESS_FLASH=false

if [ ! -f "$FILE" ]; then
    echo -e "${RED}[Error]${NC} File '$FILE' not found."
    exit 1
fi

echo -e "${GREEN}[INFO]${NC} Target file '$FILE' is found successfully!"

sdcc "$FILE" -o "$OUTPUT"

if [ $? -ne 0 ]; then
    echo -e "${RED}[Error]${NC} Compilation failed."
    SUCCESS_COMPILE=false
else
    echo -e "${GREEN}[INFO]${NC} Target file '$FILE' is compiled successfully!"
    SUCCESS_COMPILE=true
fi

if [ "$ONLY_COMPILE" = true ]; then
    find "$DIRECTORY" -type f -name "$(basename "${FILE%.c}").*" ! -name "$(basename "$FILE")" -delete
    echo -e "${GREEN}[INFO]${NC} Compilation and cleanup done."
    exit 0
fi

if [ "$SUCCESS_COMPILE" = true ]; then
    python3 /usr/local/stcgal/stcgal.py -P stc89a "$OUTPUT"
    if [ $? -ne 0 ]; then
        echo -e "${RED}[Error]${NC} Flashing failed."
        SUCCESS_FLASH=false
    else
        echo -e "${GREEN}[INFO]${NC} Target file '$FILE' is flashed successfully!"
        SUCCESS_FLASH=true
    fi
fi

find "$DIRECTORY" -type f -name "$(basename "${FILE%.c}").*" ! -name "$(basename "$FILE")" -delete

echo -e "${GREEN}[INFO]${NC} Cleanup done."

if [ "$SUCCESS_FLASH" = true ]; then
    echo -e "${GREEN}[INFO]${NC} Operation completed successfully."
else
    echo -e "${RED}[Error]${NC} Operation completed failed."
fi

