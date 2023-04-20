FROM nicolargo/glances:dev
RUN sed -i '/flush_interval/s/10000/1000/' glances/exports/glances_influxdb2.py
COPY etc/glances.conf /glances/conf/glances.conf
CMD python -m glances -C /glances/conf/glances.conf $GLANCES_OPT