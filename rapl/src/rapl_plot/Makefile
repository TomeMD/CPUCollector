CC = gcc
CFLAGS = -O3 -Wall
LFLAGS =

INFLUXDB_INCLUDE=/usr/local/include/influxdb/

PAPI_INCLUDE = ../papi-6.0.0/src
PAPI_LIBRARY = ../papi-6.0.0/src/libpapi.a

all:	rapl_plot

rapl_plot:	rapl_plot.o
	$(CC) $(LFLAGS) -o rapl_plot rapl_plot.o -linfluxdb -lcurl $(PAPI_LIBRARY)

rapl_plot.o:	rapl_plot.c
	$(CC) $(CFLAGS) -I$(PAPI_INCLUDE) -I$(INFLUXDB_INCLUDE) -c rapl_plot.c

clean:
	rm -f *~ *.o rapl_plot