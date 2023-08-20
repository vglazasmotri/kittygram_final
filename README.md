# Контейнеры и CI/CD для Kittygram
Запуск проекта Kittygram в контейнерах;
Настройка автоматического тестирования и деплой проекта на удалённый сервер.

## Стэк

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![DjangoREST](https://img.shields.io/badge/DJANGO-REST-ff1709?style=for-the-badge&logo=django&logoColor=white&color=ff1709&labelColor=blue) ![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E) ![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) ![Gunicorn](https://img.shields.io/badge/gunicorn-%298729.svg?style=for-the-badge&logo=gunicorn&logoColor=white) ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

## Описание проекта 
Kittygram - сервис для любителей котиков дает возмодность:

- Добавлять, просматривать, редактировать и удалять своих котиков.
- Добавлять новые достижения и присваивать своим котикам уже существующие.
- Просматривать чужих котов и их достижения.

___
# Установка на локальный компьютер.

## Клонируйте репозиторий:

```
git clone git@github.com:vglazasmotri/kittygram_final.git
```

```
cd kittygram
```

## Создайте файл .env и заполните его своими данными. Пример в файле .env.example:

```
# Переменные для базы данных:
POSTGRES_DB=kittygram
POSTGRES_USER=kittygram_user
POSTGRES_PASSWORD=kittygram_password
DB_NAME=kittygram
# для Django-проекта:
DB_HOST=db
DB_PORT=5432
SECRET_KEY=secret_key
ALLOWED_HOSTS="'***.*.*.*','127.0.0.1','localhost','you_domen'"
DEBUG=False
# для Docker:
BACKEND_PORT=9000
HTTP_PORT=80
DOCKER_USERNAME=dockerhub_username
APPLICATION_NAME=kittygram
```

## Установить пакет Make:

### Если у вас Windows.
- Установите chocolatey package manager 
- Установите make:
```
choco install make
```
### Если у вас Linux то make должна быть установлена по умолчанию. На всякий случай:
```
sudo apt install make
```

## Создание Docker-образов и загрузка на ваш DockerHub с помощью Makefile:

```
cd frontend
make build push
```

```
cd ../backend
make build push
```

```
cd ../nginx
make build push
```

## Чтобы запустить Docker Compose на локальном компьютере:

```
cd ..
docker compose -f docker-compose.production.yml up
```

### Соберите статику, скопируйте файлы и выполните команду migrate в Windows лучше через PowerShell:

```
docker compose -f docker-compose.production.yml exec backend python manage.py collectstatic
docker compose -f docker-compose.production.yml exec backend cp -r /app/collected_static/. /backend_static/static/
docker compose -f docker-compose.production.yml exec backend python manage.py migrate
```

### Проект доступер локально

```
http://localhost:9000/
```

___
# Деплой на сервер.

## Подключитесь к удаленному серверу

```
ssh -i путь_до_файла_с_SSH_ключом/название_файла_с_SSH_ключом имя_пользователя@ip_адрес_сервера 
```

## Создайте на сервере директорию kittygram через терминал:

```
mkdir kittygram
```

## Установка docker compose на сервер:

```
sudo apt update
sudo apt install curl
curl -fSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo apt-get install docker-compose-plugin
```

## В директорию kittygram/ скопируйте файлы docker-compose.production.yml и .env:

```
scp -i path_to_SSH/SSH_name docker-compose.production.yml username@server_ip:/home/username/kittygram/docker-compose.production.yml
* ath_to_SSH — путь к файлу с SSH-ключом;
* SSH_name — имя файла с SSH-ключом (без расширения);
* username — ваше имя пользователя на сервере;
* server_ip — IP вашего сервера.
```

## Запустите docker compose в режиме демона:

```
sudo docker compose -f docker-compose.production.yml up -d
```

## Выполните миграции, соберите статические файлы бэкенда и скопируйте их в /backend_static/static/:

```
sudo docker compose -f docker-compose.production.yml exec backend python manage.py migrate
sudo docker compose -f docker-compose.production.yml exec backend python manage.py collectstatic
sudo docker compose -f docker-compose.production.yml exec backend cp -r /app/collected_static/. /backend_static/static/
```

## На сервере в редакторе nano откройте конфиг Nginx:

```
sudo nano /etc/nginx/sites-enabled/default
```

## Измените настройки location в секции server:

```
location / {
    proxy_set_header Host $http_host;
    proxy_pass http://127.0.0.1:9000;
}
```

## Проверьте работоспособность конфига Nginx:

```
sudo nginx -t
```

Если ответ в терминале такой, значит, ошибок нет:
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

## Перезапускаем Nginx

```
sudo service nginx reload
```

___
# Настройка CI/CD

## Файл workflow находится в директории .github/workflows/

```
kittygram/.github/workflows/main.yml
```

## Для адаптации его на своем сервере добавьте секреты в GitHub Actions:

```
DOCKER_USERNAME                # имя пользователя в DockerHub
DOCKER_PASSWORD                # пароль пользователя в DockerHub
HOST                           # ip_address сервера
USER                           # имя пользователя
SSH_KEY                        # приватный ssh-ключ (cat ~/.ssh/id_rsa)
SSH_PASSPHRASE                 # кодовая фраза (пароль) для ssh-ключа

TELEGRAM_TO                    # id телеграм-аккаунта (можно узнать у @userinfobot, команда /start)
TELEGRAM_TOKEN                 # токен бота (получить токен можно у @BotFather, /token, имя бота)
```

___
# Автор
[Sergey Sych](https://github.com/vglazasmotri)