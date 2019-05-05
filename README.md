
# Docker Health Check

I run Docker both in production on CentOS, and also run it on my Macs for development
and testing. Recently, I noticed some weird behavior on my Mac's version of Docker
where sometimes containers would stop responding to inbound TCP connections, but otherwise
behave normally.  I built this test suite to catch that behavior as it happens, and see
waht changes I could make to prevent that behavior.

## Usage

First, clone this repo.

Next, start up the test container, followed by the testing script: 

`./start-nginx.sh ; ./test-nginx.sh`

If a port is specified as an argument to each script, it will be listned on, otherwise the default port of 8123 will be used.

If Docker is not running or in the process of starting up, `start-nginx.sh` will 
try to start the container once per second until it succeeds.  Once it succeeds,
testing will immediately commence.

Testing consists of running curl against the Nginx container once per second, and writing
the first line of output to a file named `results-YYYYMMDDTHHMMSS.log`.




