#!/bin/bash
#
# Start up Nginx
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

echo "# "
echo "# If Nginx container was previously running, I will now kill it..."
echo "# "
ID=$(docker kill $NAME || true)

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
	sleep 1
done

echo "# "
echo "# Nginx started, and listenong on port ${PORT}!"
echo "# "



