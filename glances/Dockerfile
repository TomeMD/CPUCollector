FROM nicolargo/glances:latest-full
COPY etc/glances.conf /etc/glances.conf
COPY etc/glances_export.py /app/glances/exports/glances_export.py
CMD python -m glances -C /etc/glances.conf $GLANCES_OPT