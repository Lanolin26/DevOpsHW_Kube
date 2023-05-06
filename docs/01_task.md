## Задание

1. Создайте web-приложение, которое выводит содержимое из папки app
2. Соберите его в виде Docker image
3. Установите image в кластер Kubernetes
4. Обеспечьте доступ к приложению извне кластера

### Пояснения

1. В качестве web-сервера для простоты можно воспользоваться Python: “python -m http.server 8000”. 
    1. Добавьте эту команду в инструкцию CMD в Dockerfile.
2. Создать Dockerfile на основе “python:3.10-alpine”, в котором.
    1. Создать каталог “/app” и назначить его как WORKDIR.
    2. Добавить в него файл, содержащий текст “Hello world”.
    3. Обеспечить запуск web-сервера от имени пользователя с “uid 1001”.
3. Собрать Docker image с tag “1.0.0”.
4. Запустить Docker container и проверить, что web-приложение работает.
5. Выложить image на Docker Hub.
6. Создать Kubernetes Deployment manifest, запускающий container из созданного image.
    1. Имя Deployment должно быть “web”.
    2. Количество запущенных реплик должно равняться двум.
    3. Добавить использование Probes.
7. Установить manifest в кластер Kubernetes.
8. Обеспечить доступ к web-приложению внутри кластера и проверить его работу
    1. Воспользоваться командой kubectl port-forward: “kubectl port-forward --address 0.0.0.0 deployment/web 8080:8000”.
    2. Перейти по адресу <http://127.0.0.1:8080/hello.html>.

### Результаты

1. Выложить результаты работы в Github
2. README.md с описанием выполненных шагов
3. Dockerfile
4. Kubernetes Deployment manifest в виде yaml
5. Результат команды “kubectl describe deployment web”
6. Прислать ссылку на Github repo или gist на e-mail Dmitriy.Zverev@nexign.com. В теме письма указать свои фамилию и имя.
