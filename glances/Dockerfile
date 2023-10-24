FROM nicolargo/glances:latest-full
COPY etc/glances.conf /etc/glances.conf
COPY start-glances.sh /usr/local/bin/glances/
ENTRYPOINT["/usr/local/bin/glances/start-glances.sh"]