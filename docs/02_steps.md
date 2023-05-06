## Выполнение

### Шаг 1. Подготовка

Создание необходимых файлов и директорий

```bash
touch Dockerfile
touch deployments.yaml

mkdir -p app
echo "Hello World" > app/helloworld
```

### Шаг 2. Создание docker образа и загрузка его в храниилище

Заполнение Dockerfile файла

```dockerfile
FROM python:3.9-alpine

ARG UID=1001
ARG author=Artem Kiselev <lanolin652@gmail.com>
ARG version=1

LABEL org.opencontainers.image.version=${version}
LABEL org.opencontainers.image.authors=${author}

USER ${UID}

WORKDIR /app

COPY --chown=${UID} app/helloworld ./helloworld

EXPOSE 8000

CMD [ "python3", "-m", "http.server", "8000" ]
```

Создание образа

```bash
docker build -t docker.io/lanolin25/kube-hw:latest .
```

Push образа в хранилище

```bash
docker tag docker.io/lanolin25/kube-hw:latest docker.io/lanolin25/kube-hw:1.0.0
docker push docker.io/lanolin25/kube-hw:latest
docker push docker.io/lanolin25/kube-hw:1.0.0
```

### Шаг 3. Подготовка окружения kube

### Шаг 4. Заполнение Manifest для деплоя приложения

### Шаг 5. Деплой приложение и проверка работы
