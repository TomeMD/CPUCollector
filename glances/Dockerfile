FROM nicolargo/glances:latest-full
COPY etc/glances.conf /glances/conf/glances.conf
CMD python -m glances -C /glances/conf/glances.conf $GLANCES_OPT