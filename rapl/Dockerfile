FROM ubuntu:jammy

# Set environment variables
ENV PAPI_VERSION=6.0.0
ENV RAPL_HOME=/var/lib/rapl
ENV PAPI_HOME=${RAPL_HOME}/papi-${PAPI_VERSION}
ENV RAPL_SRC=/var/lib/rapl/rapl_plot
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# Install basic packages
RUN apt-get update && apt-get install -y build-essential gcc libcap2-bin git

# Copy RAPL binaries and PAPI distribution
RUN mkdir -p ${RAPL_HOME}
COPY --chown=0 src ${RAPL_HOME}

# Compile PAPI
RUN cd ${PAPI_HOME}/src && \
  chmod +x configure && \
  ./configure --with-components="rapl" && \
  make

# Compile RAPL
RUN cd ${RAPL_SRC} && \
  chmod +x install-dependencies.sh && \
  ./install-dependencies.sh && \
  make && \
  setcap cap_sys_rawio=ep ${RAPL_SRC}/rapl_plot && \
  chmod +x ${RAPL_SRC}/rapl_plot

# Execute rapl_plot
ENTRYPOINT ["/var/lib/rapl/rapl_plot/rapl_plot"]
