#!/bin/bash
#
# Test out Nginx for basic connectivity
#

# Errors are fatal
set -e

PORT=8123

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

	curl -s localhost:${PORT} | head -n1 | ts | tee $FILENAME
	sleep 1

done


