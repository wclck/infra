Server setup

1. Update and upgrade repository:
   sudo apt update
   sudo apt upgrade

2. Install firewall
   apt install ufw

3. Enable and config
ufw default deny incoming && ufw default allow outgoing
ufw allow 22
ufw allow 222
other ports

Apply config
ufw disable && ufw enable

ssh config

add user
sudo adduser www
sudo adduser www sudo

generate ssh key:
ssh-keygen -t ed25519

generate ssh pub key:
cat ~/.ssh/id_ed25519.pub | pbcopy

edit ssh config:
sudo nano /etc/ssh/sshd_config

copy ssh key on server:
ssh-copy-id -i .ssh/_.pub www@__

edit ssh config settings:
AllowUsers www

PermitRootLogin no

PasswordAuthentication no

Port 222

restart ssh server:
sudo service ssh restart

nstall marzban

Marzban with warp
bash <(wget --no-check-certificate -O - https://checkvpn.net/files/install_marz_auto_random_pass_443_warp_edition.sh)

Marzban no warp
sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install

SSL cert
Install cron socat
sudo apt install cron socat
acme.sh
curl https://get.acme.sh | sh -s email=it@weclick.tech

Cert dir
sudo mkdir -p /var/lib/marzban/certs/

Cert request
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt --issue --standalone -d subscription3.weclick.tech \
 --key-file /var/lib/marzban/certs/key.pem \
 --fullchain-file /var/lib/marzban/certs/fullchain.pem

Activate cert
sudo nano /opt/marzban/.env

-UVICORN_PORT = 8000
+UVICORN_PORT = 8443
-# UVICORN_SSL_CERTFILE = "/var/lib/marzban/certs/example.com/fullchain.pem"
-# UVICORN_SSL_KEYFILE = "/var/lib/marzban/certs/example.com/key.pem"
+UVICORN_SSL_CERTFILE = "/var/lib/marzban/certs/fullchain.pem"
UVICORN_SSL_KEYFILE = "/var/lib/marzban/certs/key.pem"
-# XRAY_SUBSCRIPTION_URL_PREFIX = "https://example.com"
+XRAY_SUBSCRIPTION_URL_PREFIX = https://subscription.weclick.tech:8443

Restart
sudo marzban restart

Install tg bot

Install backup script
Панель с sqlite:
bash <(curl -Ls https://github.com/wclck/backup-sqlite/raw/main/backup.sh)

Панель с mysql в docker:
https://github.com/wclck/backup
bash <(curl -Ls https://github.com/wclck/backup/raw/main/backup.sh)

Install subscription page
https://github.com/MuhammadAshouri/marzban-templates/tree/master/template-01
cd /opt/marzban
apt install wget
wget -O index.html https://raw.githubusercontent.com/wclck/subs-page-template/main/index.html
OR

Edit locally and upload to server (or take from backup)
scp -p222 index.html srv%:~/
mv /home/www/index.html /opt/marzban

Add string to docker compose:
- /opt/marzban/index.html:/code/app/templates/subscription/index.html

sudo marzban restart


Install Node
Run warp on node
docker run --restart=always -itd --name warp_socks_v3 -p 127.0.0.1:40000:9091 monius/docker-warp-socks:v3
MySQL

Создание тома для данных MySQL

docker volume create mysql

Инициализация базы данных

Для инициализации базы данных необходимо запустить контейнер с MySQL, задав следующие переменные окружения:

Осторожно
Данные значения приведены справочно.
Заполните содержимое своими значениями.
￼


Окно терминала
docker run -d --rm --name mysql -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=super-puper-password -e MYSQL_ROOT_HOST=127.0.0.1 -e MYSQL_DATABASE=marzban -e MYSQL_PASSWORD=super-password -e MYSQL_USER=marzban mysql:8.3 --character_set_server=utf8mb4 --collation_server=utf8mb4_unicode_ci --innodb-redo-log-capacity=134217728 --disable-log-bin --mysqlx=OFF

Также нужно создать пользователя backup c правами только на чтение базы marzban:
Подключение к sql:
docker exec -it marzban-mysql-1 mysql -p

Создание пользователя:
CREATE USER 'backup' IDENTIFIED BY ‘INSERT_PASSWORD;

Выдача прав только на чтение базы:
GRANT SELECT, SHOW VIEW, LOCK TABLES ON marzban.* TO 'backup'@'%';


Остановка контейнера
После инициализации базы данных контейнер необходимо остановить контейнер, использовав следующую команду, введя пароль суперпользователя по запросу:

docker exec -it mysql mysqladmin shutdown -u root -p

Интеграция
Для интеграции MySQL с приложением Marzban через docker-compose, необходимо добавить соответствующие сервисы в docker-compose.yml файл.

sudo nano /opt/marzban/docker-compose.yml


services:
  marzban:
    image: gozargah/marzban:latest
    env_file: .env
    network_mode: host
    volumes:
      - /var/lib/marzban:/var/lib/marzban
    depends_on:
      - mysql
  mysql:
    image: mysql:8.3
    ports: - 3306:3306
    #network_mode: host
    command:
      - --mysqlx=OFF
      - --bind-address=0.0.0.0
      - --character_set_server=utf8mb4
      - --collation_server=utf8mb4_unicode_ci
      - --disable-log-bin
      - --host-cache-size=0
      - --innodb-open-files=1024
      - --innodb-buffer-pool-size=268435456
    volumes:
      - mysql:/var/lib/mysql
volumes:
  mysql:
    external: true
    name: mysql

Здесь мы устанавливаем некоторые параметры, рассмотрим их немного подробнее:
￼
Установка строки подключения к базе данных
В файле .env, необходимом для работы вашего приложения, следует указать строку подключения к базе данных, используя данные, заданные при инициализации контейнера:

sudo nano /opt/marzban/.env

Перед заполнением строки подключения, убедитесь, что вы используете правильные учетные данные, заданные в шаге 2, при инициализации контейнера MySQL:
SQLALCHEMY_DATABASE_URL = "mysql+pymysql://<имя пользователя для базы Marzban>:<пароль пользователя для базы Marzban>@127.0.0.1:3306/<имя базы Marzban>"


Осторожно
Данные значения приведены справочно.
￼

Эта строка позволит вашему приложению подключаться к базе данных MySQL, настроенной в Docker, обеспечивая безопасное и удобное управление данными.

Перезапускаем контейнер

sudo marzban restart

Перенос данных из SQLite в MySQL
Процедура переноса данных включает создание дампа данных из вашей старой базы данных SQLite, предоставление этого дампа контейнеру MySQL и, наконец, перенос данных из SQLite в MySQL. Ниже представлены шаги и команды для выполнения этих задач.
Создание дампа из старой базы SQLite:
Для выполнения дампа базы данных SQLite, нам потребуется пакет для работы с ней

sudo apt install sqlite3

Создадим дамп с данными из вашей базы данных SQLite, используя следующую команду:

sqlite3 /var/lib/marzban/db.sqlite3 '.dump --data-only' | sed "s/INSERT INTO \([^ ]*\)/REPLACE INTO \`\\1\`/g" > /tmp/dump.sql

Эта команда выполняет дамп данных из файла db.sqlite3, находящегося в каталоге /var/lib/marzban, конвертирует инструкции INSERT INTO в REPLACE INTO для обеспечения совместимости с MySQL и сохраняет результат в файл /tmp/dump.sql.

Предоставление пути к дампу для MySQL:
Далее, перенесите созданный дамп в контейнер MySQL с помощью команды:

cd /opt/marzban && docker compose cp /tmp/dump.sql mysql:/dump.sql

Переходите в каталог вашего проекта Marzban /opt/marzban и используйте docker compose cp для копирования файла дампа в контейнер mysql.
Перенос данных из SQLite в MySQL:
Перед выполнением переноса данных, убедитесь, что вы используете правильные учетные данные, заданные в шаге 2, при инициализации контейнера MySQL:

Осторожно
Данные значения приведены справочно.
￼
Заметка
Важно, что в этой команде пароль указывается непосредственно после -p без пробела, что является стандартной практикой для MySQL.

Теперь вы можете выполнить перенос данных, запустив следующую команду в контейнере MySQL:

docker compose exec mysql mysql -u <имя пользователя для базы Marzban> -p<пароль пользователя для базы Marzban> -h 127.0.0.1 <имя базы Marzban> -e "SET FOREIGN_KEY_CHECKS = 0; SET NAMES utf8mb4; SOURCE /dump.sql;"

После выполнения команды начнется процесс переноса данных.
