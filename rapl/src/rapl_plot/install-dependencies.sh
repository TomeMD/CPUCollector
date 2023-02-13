#!/bin/sh

cd /var/lib/rapl/

# Install general dependencies
apt-get install -y autoconf libcurl4-gnutls-dev cmake doxygen valgrind pkg-config libtool

# Install libjson (required for installing InfluxDB C libraries)
git clone https://github.com/json-c/json-c.git
mkdir json-c/json-c-build
cd json-c/json-c-build
cmake ..
make
make test
# optionally don' use valgrind - make USE_VALGRIND=0 test
make install

# Install InfluxDB C libraries
cd /var/lib/rapl
git clone https://github.com/influxdata/influxdb-c.git
cd influxdb-c
./bootstrap
./configure
make
make install