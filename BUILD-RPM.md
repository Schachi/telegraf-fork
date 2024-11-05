## Telegraf RPM Paket bauen

### Image zum Erstellen des Telegraf Pakets bauen

Image aus Dockerfile bauen:
```
docker build --progress plain -t telegrafbuild .

bzw. mit BuildKit:

DOCKER_BUILDKIT=1 docker build -t telegrafbuild:latest .
```

Ggf. Image zum Transport in tar speichern:
```
docker save -o telegrafbuild.tar telegrafbuild:latest
```

Ggf. Image aus tar laden:
```
docker load -i telegrafbuild.tar
```

### Telegraf RPM Paket bauen

Container aus Image starten:
```
docker run --network host --name telegrafbuild-0000 -u root -it telegrafbuild /bin/sh
```

Oder wenn der Container bereits existiert, in den Container gehen:
```
docker start telegrafbuild-0000
docker exec -it telegrafbuild-0000 /bin/bash
```

Original Telegraf Projekt aus Git klonen und gewünschte Version wählen:
```
git clone https://github.com/Schachi/telegraf-fork
cd telegraf-fork
git checkout IT-6114
```

Ggf. Update holen:
```
git pull
```

Ggf. Versionsinfo des zu bauenden Pakets anpassen:
```
nano build_version.txt

Hinweise:
Wegen semver sind nur Bezeichnungen in der Form vMAJOR.MINOR.PATCH erlaubt.
Allerdings führt ein v ganz vorne zu dem Fehler "panic: strconv.ParseInt: parsing "v1": invalid syntax".
Es sind also tatsächlich nur Ziffern und die zwei Punkte erlaubt!

z.B.:
1.32.22024110501
```

Von Telegraf vor der Einreichung von Pull Requests vorgesehen Schritte durchführen,  
siehe: https://github.com/influxdata/telegraf/blob/release-1.32/CONTRIBUTING.md:
```
export CGO_ENABLED=1
make lint
make check
make check-deps
make test
make docs
```

RPM-Paket bauen:
```
cd telegraf-fork
make package include_packages=x86_64.rpm
```

Von außerhalb des Containers das gebaute Paket kopieren:
```
Z.B.:
docker cp telegrafbuild-0000:/usr/src/app/telegraf-fork/build/dist/telegraf-1.32.22024110501~5cdd2487-0.x86_64.rpm .
