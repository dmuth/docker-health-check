#!/bin/bash
#
# Start up Nginx
#

# Errors are fatal
set -e

NAME="test_nginx"

echo "# "
echo "# Stopping Nginx..."
echo "# "

ID=$(docker kill $NAME)

echo "# "
echo "# Nginx stopped!"
echo "# "


