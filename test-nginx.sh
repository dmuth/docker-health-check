#!/bin/bash
#
# Test out Nginx for basic connectivity
#

# Errors are fatal
set -e

PORT=8123

if test "$1" == "-h" -o "$1" == "--help"
then
	echo "! "
	echo "! Syntax: $0 [ port ]"
	echo "! "
	exit 1
fi

if test "$1"
then
	PORT=$1
fi

FILENAME="test-results-$(date +%Y%m%dT%H%M%S).log"

echo "# "
echo "# Testing against http://localhost:${PORT}/..."
echo "# "
echo "# Writing test results to ${FILENAME}..."
echo "# "
echo "# Press ^C to stop testing..."
echo "# "

while true
do

	curl -s localhost:${PORT} | head -n1 | ts | tee -a $FILENAME
	sleep 1

done


