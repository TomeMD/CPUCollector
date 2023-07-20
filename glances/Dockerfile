FROM nicolargo/glances:latest-full
COPY etc/glances.conf /etc/glances.conf
CMD python -m glances -C /etc/glances.conf $GLANCES_OPT