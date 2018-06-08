# Структура проекта
```
.  
├── config.yaml         # В этом файле набор переменных и окружений для деплоя в kubernetes  
├── Dockerfile          # В этом Dockerfile собирается наш проект (в нашем случае nginx)  
├── index.html          # Это единственный файл проекта (код), при сборке docker образа он попадает в каталог /usr/share/nginx/html  
├── docker-compose.yml  # Конфигурация для сборки образов и запуска контейнеров на локальной машине
├── .gitlab-ci.yml      # Тут описано как собирать и деплоить проект в gitlab CI  
├── README.md           # Мы тут  
└── templates           # Каталог с шаблонами ресурсов kubernetes, все шаблоны в том числе вложенные подгружаются отсюда  
    ├── deployment.yaml.j2      # Шаблон Kubernetes Deployment https://kubernetes.io/docs/user-guide/deployments/  
    └── service.yaml.j2         # Шаблон Kubernetes Service https://kubernetes.io/docs/user-guide/services/  
```
# Как использовать?
* Создаём у себя Dockerfile или берём из этого репозитория и модифицируем
* Берём config.yaml docker-compose.yml .gitlab-ci.yml и каталог templates

### Получаем доступ в Kubernetes Staging
https://confluence.2gis.ru/display/CD/Kubernetes+quick+start+guide
### Меняем конфигурацию
В config.yaml меняем эти переменные:  
```yaml
...
  k8s_namespace: < пишем тут полученный namespace >
  app_name: < тут пишем название нового приложения >
  app_port: < тут порт, на котором работает приложение >
...
```
В docker-compose.yml меняем image и ports:  
```yaml
...
ports: # Если не нужен проброс портов удаляем
  - "8080:< порт на котором слушает приложение >"
image: docker-hub.2gis.ru/2gis-< имя команды >/< имя образа >:${TAG}
...
```

### Проверяем, что локально всё работает
```bash
$ TAG=latest docker-compose up -d
Starting k8sstarterkit_nginx_1
$ curl localhost:8080
Hello 2GIS!
$ docker-compose down
WARNING: The TAG variable is not set. Defaulting to a blank string.
Stopping k8sstarterkit_nginx_1 ... done
Removing k8sstarterkit_nginx_1 ... done
Removing network k8sstarterkit_default
```
[How to install docker-compose](https://docs.docker.com/compose/install/)
### Задаём переменные в Gitlab CI
Заходим в https://gitlab.2gis.ru/<владелец форка>/k8s-starter-kit/variables и добавляем переменную:  
* K8S_TOKEN - тот, что получили в Kubernetes quick start guide

### Делаем git commit и git push
```bash
$ git checkout -b add-ci-to-project
$ git commit -am "Add CI for my application"
$ git push origin add-ci-to-project
```
Появится ссылка на новый MR от gitlab, переходим создаём MR, показываем всем, получаем 2 LGTM и мержим в мастер
### Проверяем, что всё завелось
```bash
$ curl < app_name >.web-staging.2gis.ru
Hello 2GIS!
$
```
### Что дальше?
* После этого можно подтюнить лимиты для приложения и количество реплик в config.yaml
* В gitlab-ci.yml, добавляем секцию с запуском тестов для своего приложения, чтобы при создании MR прогонялись тесты
