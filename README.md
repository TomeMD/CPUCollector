# Instrucciones de ejecución

El despliegue de los contenedores Glances, InfluxDB y Grafana se puede realizar de dos formas:

- [Despliegue manual](#manual): Utilizando comandos Docker.
- [Despliegue automatizado](#auto): Utilizando Docker-Compose.


<a name="manual"></a>
## Despliegue manual

Inicialmente será necesario crear la red a través de la cuál se comunicarán InfluxDB y Grafana:

```shell
docker network create -d bridge --opt com.docker.network.bridge.name=br_grafana grafana_network
```

Y crear una imagen para los contenedores para los que sea necesario, en este caso, los contenedores RAPL, Glances e InfluxDB:

```shell
docker build -t rapl ./rapl
```

```shell
docker build -t glances ./glances
```

```shell
docker build -t myinfluxdb ./influxdb
```

Tras ello, se inician los contenedores de forma ordenada.



**En primer lugar, se levanta el contenedor InfluxDB**:

```shell
docker run -d --name influxdb -p 8086:8086 --restart=unless-stopped \
					-e "DOCKER_INFLUXDB_INIT_MODE=setup" \
					-e "DOCKER_INFLUXDB_INIT_USERNAME=root" \
					-e "DOCKER_INFLUXDB_INIT_PASSWORD=MyPassword" \
					-e "DOCKER_INFLUXDB_INIT_ORG=tomemd" \
					-e "DOCKER_INFLUXDB_INIT_BUCKET=glances" \
					-e "DOCKER_INFLUXDB_INIT_RETENTION=4w" \
					-e "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=MyToken" \
					-e "DOCKER_INFLUXDB_INIT_CLI_CONFIG_NAME=MyConfig" \
					-v $PWD/influxdb/data:/var/lib/influxdb2 \
					-v $PWD/influxdb/etc:/etc/influxdb2 \
					--network grafana_network myinfluxdb
```



**Ahora se levanta el contenedor Grafana:**

```shell
docker run -d --name grafana -p 8080:3000 --restart=unless-stopped -u 472 -v $PWD/grafana/data:/var/lib/grafana --network grafana_network grafana/grafana
```



**Por último, se levantan los contenedores Glances y RAPL:**

Glances:
```shell
docker run -d --name glances --pid host --privileged --network host --restart=unless-stopped -e GLANCES_OPT="-q --export influxdb2 --time 10" -v $PWD/glances/etc/glances.conf:/glances/conf/glances.conf nicolargo/glances:latest-full
```

RAPL:
```shell
docker run -d --name rapl --pid host --privileged --network host --restart=unless-stopped rapl
```


Una vez desplegados, si se quieren parar los contenedores:

```shell
docker stop rapl
docker stop glances
docker stop grafana
docker stop influxdb
```

Una vez parados, si se quiere eliminar los contenedores de forma permanente:

```shell
docker rm rapl
docker rm glances
docker rm grafana
docker rm influxdb
```


<a name="auto"></a>
## Despliegue automatizado

Para levantar los contenedores de forma automatizada simplemente habrá que ejecutar:

```shell
docker-compose up -d
```

Para parar los contenedores:

```shell
docker compose stop
```

Para parar y eliminar los contenedores:

```shell
docker compose down
```

