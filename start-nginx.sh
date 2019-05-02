#!/bin/bash
#
# Start up Nginx
#

# Errors are fatal
set -e

NAME="test_nginx"
PORT=8123

ID=$(docker kill $NAME || true)

echo "# "
echo "# Starting nginx..."
echo "# "

ID=$(docker run -d --name $NAME -p $PORT:80 --rm nginx)

echo "# "
echo "# Nginx started!"
echo "# "



