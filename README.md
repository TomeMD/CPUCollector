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

Y crear una imagen personalizada a partir de la imagen de InfluxDB oficial:

```shell
docker build -t influxdb ./influxdb
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
					--network grafana_network influxdb
```



**Ahora se levanta el contenedor Grafana:**

```shell
docker run -d --name grafana -p 8080:3000 --restart=unless-stopped -u 472 -v $PWD/grafana/data:/var/lib/grafana --network grafana_network grafana/grafana
```



**Por último, se levanta el contenedor Glances**

```shell
docker run -d --name glances --pid host --privileged --network host --restart=unless-stopped -e GLANCES_OPT="-q --export influxdb2 --time 10" -v $PWD/glances/etc/glances.conf:/glances/conf/glances.conf nicolargo/glances:latest-full
```



Una vez desplegados, si se quieren parar los contenedores:

```shell
docker stop glances
docker stop grafana
docker stop influxdb
```

Una vez parados, si se quiere eliminar los contenedores de forma permanente:

```shell
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

