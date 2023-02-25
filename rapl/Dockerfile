FROM ubuntu:latest

# Set environment variables
ENV RAPL_OUTPUT_PREFIX=out
ENV RAPL_SECONDS_INTERVAL=2
ENV PAPI_VERSION=6.0.0

# Install basic packages
RUN apt-get update && apt-get install -y build-essential gcc libcap2-bin git

# Copy RAPL binaries and PAPI distribution
RUN mkdir -p /var/lib/rapl 
COPY --chown=0 src /var/lib/rapl

# Compile PAPI
RUN cd /var/lib/rapl/papi-${PAPI_VERSION}/src && \
  chmod +x configure && \
  ./configure --with-components="rapl" && \
  make

# Compile RAPL
RUN cd /var/lib/rapl/rapl_plot && \
  chmod +x install-dependencies.sh && \
  ./install-dependencies.sh && \
  make clean && make && \
  chmod +x /var/lib/rapl/start_rapl.sh

# Execute rapl_plot
ENTRYPOINT ["/var/lib/rapl/start_rapl.sh"]