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

FILENAME="results-$(date +%Y%m%dT%H%M%S).log"

echo "# "
echo "# Testing against http://localhost:${PORT}/..."
echo "# "
echo "# Writing test results to ${FILENAME}..."
echo "# "
echo "# Press ^C to stop testing..."
echo "# "

CURL_OPTS="--connect-timeout 2 -s -S --retry 3 --retry-connrefused --retry-delay 1"
while true
do

	curl $CURL_OPTS localhost:${PORT} | head -n1 | ts | tee -a $FILENAME

	RETVAL=${PIPESTATUS[0]}
	if test "${RETVAL}" -ne 0
	then
		echo "CURL FAILED with status code: $RETVAL" >&2
		exit 1
	fi

	sleep 1

done


