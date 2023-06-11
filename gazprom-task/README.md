# Для использования с Docker-compose

Конфигурационные файлы должны находится по пути: /app1/conf для первого и /app2/conf для второго.
Для запуска необходимо находится в директории проекта.

## Команды для сборки образов
```bash
docker build -t app1:0.0.5 .
docker build -t app2:0.1.1 .
```

## Команда для запуска 
 ```bash
    docker-compose up -d
```

# Для использования с systemd

## Команды для запуска 
```bash
cd gazprom/
mv *.service /etc/systemd/system
chmod +x app*/bin/app*

systemctl daemon-reload
systemctl enable app1 app2-1 app2-2

systemctl start app1

systemctl status app1
systemctl status app2-1
systemctl status app2-2
```
