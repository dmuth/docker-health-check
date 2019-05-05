
# Docker Health Check

I run Docker both in production on CentOS, and also run it on my Macs for development
and testing. Recently, I noticed some weird behavior on my Mac's version of Docker
where sometimes containers would stop responding to inbound TCP connections, but otherwise
behave normally.  I built this test suite to catch that behavior as it happens, and see
waht changes I could make to prevent that behavior.

## Usage


bash <(curl -s https://raw.githubusercontent.com/dmuth/docker-health-check/master/go.sh) [ PORT ]

If a port is specified as an argument, it will be listned on, otherwise the default port of 8123 will be used.

If Docker is not running or in the process of starting up, the script will 
try to start the container once per second until it succeeds.  Once it succeeds,
testing will immediately commence.

Testing consists of running curl against the Nginx container once per second, and writing
the first line of output to a file named `results-YYYYMMDDTHHMMSS.log`.

If the container is killed (or Docker is stopped), the script will try to restart the 
container once per second until it succeeds, then resume testing, with the results going
to a new file.


## Interpreting Results

To see the results of tests, run `wc -l results-*`.  Example:

```
wc -l results-*
      19 results-20190505T135448.log
      60 results-20190505T135605.log
    8570 results-20190505T135711.log
```

The timestamp on the file will tell when the test was started, and the number of
lines will tell how many seconds nginx responded for.  In this case, there were a 
few short-lived tests and then a test that ran for well over two hours.

In the failure scenario that I had when originally writing this test, Docker containers would stop
responding to TCP traffic within 30 minutes, yet I could `docker run -it ID bash` and 
connect to those containers, and run `curl` from them, etc.


## Contact

My email is doug.muth@gmail.com.  I am also <a href="http://twitter.com/dmuth">@dmuth on Twitter</a> 
and <a href="http://facebook.com/dmuth">Facebook</a>!



