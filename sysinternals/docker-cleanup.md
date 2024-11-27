## Поиск больших файлов

```bash
du -sh /* | sort -hr
```
покажет сколько занимает каждая из директорий или файлов в корне файловой системы

```bash
du -sh /var/lib/docker/* | sort -hr
```

## Очистка


* STOP SERVICE
```bash
sudo service docker stop
```

* CLEAN THE OVERLAY

```bash
sudo rm -rf /var/lib/docker/overlay2/*
```

* PRUNE DOCKER
```bash
docker system prune -af
```

* RESTART CONTAINER
    (пример на outline)
  
```bash
/opt/outline/persisted-state/start_container.sh
```

* RESTART THE SERVICE
```bash
sudo service docker restart
```
