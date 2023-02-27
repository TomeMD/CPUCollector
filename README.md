# Instrucciones de ejecución
En función de nuestras preferencias, podemos desplegar los contenedores utilizando [Docker](#docker) o utilizando [Apptainer](#apptainer).

<a name="docker"></a>
## Despliegue con Docker

El despliegue de los contenedores Glances, InfluxDB y Grafana se puede realizar de dos formas:

- [Despliegue manual](#manual): Utilizando comandos Docker.
- [Despliegue automatizado](#auto): Utilizando Docker-Compose.

---
<a name="manual"></a>
### Despliegue manual

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

---
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

<a name="apptainer"></a>
## Despliegue con Apptainer

El despliegue de los contenedores Glances, InfluxDB y Grafana se puede realizar de dos formas:

- [Despliegue manual](#manual): Utilizando comandos Apptainer.
- [Despliegue automatizado](#auto): Utilizando Singularity-Compose.

---
<a name="manual"></a>
### Despliegue manual

Inicialmente será necesario crear una imagen (fichero .sif) para los contenedores para los que sea necesario, en este caso, los contenedores RAPL, Glances e InfluxDB:

```shell
apptainer build rapl/rapl.sif rapl/rapl.def
```

```shell
apptainer build glances/glances.sif glances/glances.def
```

```shell
apptainer build influxdb/influxdb.sif influxdb/influxdb.def
```


Para iniciar la ejecución de los contenedores en segundo plano debemos crear una instancia para cada contenedor.

**En primer lugar, se levanta la instancia InfluxDB**:

```shell
apptainer instance start --env "DOCKER_INFLUXDB_INIT_MODE=setup" --env "DOCKER_INFLUXDB_INIT_USERNAME=root" --env "DOCKER_INFLUXDB_INIT_PASSWORD=MyPassword" --env "DOCKER_INFLUXDB_INIT_ORG=tomemd" --env "DOCKER_INFLUXDB_INIT_BUCKET=glances" --env "DOCKER_INFLUXDB_INIT_RETENTION=4w" --env "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=MyToken" --env "DOCKER_INFLUXDB_INIT_CLI_CONFIG_NAME=MyConfig" --bind ./influxdb/data:/var/lib/influxdb2 --bind ./influxdb/etc:/etc/influxdb2 influxdb/influxdb.sif influxdb
```

**Ahora se levanta la instancia Grafana:**

```shell
apptainer instance start --bind ./grafana/data:/var/lib/grafana docker://grafana/grafana grafana
```

**Por último, se levantan las instancias Glances y RAPL:**

Glances:
```shell
apptainer instance start -C --env "GLANCES_OPT=-q --export influxdb2 --time 10" --bind ./glances/etc/glances.conf:/glances/conf/glances.conf glances/glances.sif glances
```
-v $PWD/glances/etc/glances.conf:/glances/conf/glances.conf
RAPL:
```shell
apptainer instance start -C --add-caps rapl/rapl.sif rapl
```

Una vez desplegadas, si se quieren parar y eliminar las instancias:

```shell
apptainer instance stop rapl
apptainer instance stop glances
apptainer instance stop grafana
apptainer instance stop influxdb
```

---
<a name="auto"></a>
## Despliegue automatizado

Para levantar las instancias de forma automatizada habrá que ejecutar:

```shell

```

Para parar y eliminar las instancias:

```shell

```