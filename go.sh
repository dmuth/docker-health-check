#!/bin/bash
#
# This script is to test basic Docker functionality, and I originally wrote it for when
# Docker began misbehaving on OS/X
#
# Source: https://github.com/dmuth/docker-health-check
#
# It will do the following:
#
# 1) Start an Nginx Docker continue, and continue trying to start one until successful.
# 2) Run curl against that container once per second.
# 3) Store the results in a text file that starts with "results-" and a timestamp
# 4) If curl exits with an error, attempt to restart the container. 
#
# Note that #4 will survive Docker restarts, and the entire script must be 
# killed with ctrl-C or else it will run forever.
#

# Errors are fatal
set -e

NAME="docker_test_nginx"
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

function start_nginx() {

	echo "# "
	echo "# If Nginx container was previously running, I will now kill it..."
	echo "# "
	ID=$(docker kill $NAME 2>&1 || true)

	echo "# "
	echo "# If there was a stopped copy of that container, I will now remove it..."
	echo "# "
	ID=$(docker rm $NAME 2>&1 || true)

	echo "# "
	echo "# Starting Nginx conatiner, listening on port ${PORT}..."
	echo "# "

	ID=""

	#
	# Try once every second to start Nginx, until we succeed.
	#
	while test ! "$ID"
	do
		ID=$(docker run -d --name $NAME -p $PORT:80 --rm nginx || true)
		if test ! "$ID"
		then
			echo "# Could not start nginx, sleeping for 1 second and trying again..."
		fi
		sleep 1
	done

	echo "# "
	echo "# Nginx started, and listening on port ${PORT}!"
	echo "# "

} # End of start_nginx()


CURL_OPTS="--connect-timeout 2 -s -S --retry 3 --retry-connrefused --retry-delay 1"

#
# Go through a loop where we start Nginx and run curl against it.
#
while true
do

	start_nginx

	FILENAME="results-$(date +%Y%m%dT%H%M%S).log"

	echo "# "
	echo "# Testing against http://localhost:${PORT}/..."
	echo "# "
	echo "# Writing test results to ${FILENAME}..."
	echo "# "
	echo "# Press ^C to stop testing..."
	echo "# "

	while true
	do
		curl $CURL_OPTS localhost:${PORT} | head -n1 | ts | tee -a $FILENAME

		RETVAL=${PIPESTATUS[0]}
		if test "${RETVAL}" -ne 0
		then
			echo "CURL FAILED with status code: $RETVAL" >&2
			break
		fi

		sleep 1

	done

	echo "# "
	echo "# I see that Nginx is no longer running/accepting connections, let's start it again!"
	echo "# "
	sleep 1

done

