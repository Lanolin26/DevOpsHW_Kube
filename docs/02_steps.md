## Выполнение

### Шаг 1. Подготовка

Создание необходимых файлов и директорий

```bash
touch Dockerfile
touch deployments.yaml

mkdir -p app
echo "Hello World" > app/hello.html
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

COPY --chown=${UID} app/hello.html ./hello.html

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

Устанавливаем minikube или другое ПО для создания кластера Kubernates.

По итогу вызов команды ``kubectl cluster-info`` должен выдать ответ о рабочем кластере. Например:

```plain
Kubernetes control plane is running at https://kubernetes.docker.internal:6443
CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Шаг 4. Заполнение Manifest для деплоя приложения

Заполним манифест для Deployments:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: web
          image: docker.io/lanolin25/kube-hw:latest
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
          ports:
            - name: web-port
              containerPort: 8000
          liveProbe:
            httpGet:
              path: /hello.html
              port: web-port
            initialDelaySeconds: 5
            periodSeconds: 5
```

### Шаг 5. Деплой приложение и проверка работы

Деплоим приложение при помощи команды:

```bash
kubectl apply -f ./deployments.yml
```

Проверяем, что deployments создался и уже начал настраиваться и запускаться.
Запустим команду ``kubectl describe deployment web``:

```plain
Name:                   web
Namespace:              default
CreationTimestamp:      Sun, 14 May 2023 16:59:04 +0300
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=web
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=web
  Containers:
   web:
    Image:      docker.io/lanolin25/kube-hw:latest
    Port:       8000/TCP
    Host Port:  0/TCP
    Limits:
      cpu:        500m
      memory:     128Mi
    Liveness:     http-get http://:web-port/hello.html delay=5s timeout=1s period=5s #success=1 #failure=3
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   web-567fccb787 (2/2 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  2m27s  deployment-controller  Scaled up replica set web-567fccb787 to 2
```

Проверим доступность nginx. Для этого выполним команду `kubectl port-forward --address 0.0.0.0 deployment/web 8080:8000`.

Для проверки сделаем web запрос на <http://127.0.0.1:8080/hello.html>. (``Invoke-WebRequest -Uri http://127.0.0.1:8080/hello.html``)
Получим ответ:

```plain
StatusCode        : 200
StatusDescription : OK
Content           : Hello world
RawContent        : HTTP/1.0 200 OK
                    Server: SimpleHTTP/0.6
                    Server: Python/3.9.16
                    Date: Sun, 14 May 2023 14:11:50 GMT
                    Content-Type: text/html
                    Content-Length: 11
                    Last-Modified: Sun, 14 May 2023 13:46:38 GMT

                    Hello …
Headers           : {[Server, System.String[]], [Date, System.String[]], [Content-Type, System.String[]], [Content-Leng
                    th, System.String[]]…}
Images            : {}
InputFields       : {}
Links             : {}
RawContentLength  : 11
RelationLink      : {}
```

Deployments работает и отдает контент.
