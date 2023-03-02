CC = gcc
CFLAGS = -O3 -Wall

INFLUXDB_INCLUDE = ../influxdb-c/src
INFLUXDB_LIBRARY = /usr/local/lib/libinfluxdb.a
JSON_C_LIBRARY = /usr/local/lib/libjson-c.a
PAPI_INCLUDE = ../papi-${PAPI_VERSION}/src
PAPI_LIBRARY = ../papi-${PAPI_VERSION}/src/libpapi.a

all:	rapl_plot

rapl_plot:	rapl_plot.o
	$(CC) -o rapl_plot rapl_plot.o $(INFLUXDB_LIBRARY) $(JSON_C_LIBRARY) $(PAPI_LIBRARY) -lcurl

rapl_plot.o:	rapl_plot.c
	$(CC) $(CFLAGS) -I$(PAPI_INCLUDE) -I$(INFLUXDB_INCLUDE) -c rapl_plot.c

clean:
	rm -f *~ *.o rapl_plot
