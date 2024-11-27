<h1 align="left">Backup</h1>

###

<p align="left">With these scripts, you can backup important information such as database,settings and certificates from your marzban panel and send it to Telegram with the help of the Telegram bot so that it is always available!</p>

###

<br clear="both">

<p align="left">‏<br>‏</p>

###
<h1 align="left">Differencies in the scripts</h1>

###

[backup-no-sql](https://github.com/wclck/backup/blob/main/backup-no-sql.sh)
  doesn't copy any mysql data, it copies only marzban files and sqlite database

[backup](https://github.com/wclck/backup/blob/main/backup.sh)
  also copies mysql data from the mysq docker container via mysqldump and puts it in the same archive

###
<h1 align="left">How does it work</h1>

###

<h3 align="left">Step 1: run the script</h3>

###

<p align="left">First, you run this command on your server<br><br></p> 

```bash
bash <(curl -Ls https://github.com/wclck/backup/raw/main/backup-no-sql.sh)
```
<p align="left">OR<br><br></p>

```bash
bash <(curl -Ls https://github.com/wclck/backup/raw/main/backup.sh)
``` 

###

<h3 align="left">Step 2 : Token setting</h3>

###

<p align="left">Then it asks us for bot token, you have to create a bot from https://t.me/BotFather and give the token</p>

###

<h3 align="left">Step 3: Set chat id</h3>

###

<p align="left">Then it asks us for a number of chat IDs you need and chat IDs, and to get your chat ID or the channel you set aside for backup, you must forward a message from yourself or the channel to this https://t.me/userinfobot bot, which will give you a chat ID.</p>

###

<h3 align="left">Step 4 : Caption setting</h3>

###

<p align="left">The next step asks you for a caption, which you can leave blank</p>

###

<h3 align="left">Step 5 : Cronjob setting</h3>

###

<p align="left">The cron job is set to 12am daily by default, you can change it manually before running the script here:
  https://github.com/wclck/backup/blob/a98101e9a470990795836d8b7894243d835ba847/backup.sh#L8
https://github.com/wclck/backup/blob/8d9618fa6b27454477e8a44ee01fc1be750196e1/backup-no-sql.sh#L8
</p>

###

<h3 align="left">Step 6 : question of removing previous crown jobs</h3>

###

<p align="left">Then it will ask you if you want to delete the previously defined cron jobs or not?<br>Enter y if you want it to be cleared otherwise enter n</p>

###

<h1 align="left">Possible problems</h1>

###

<p align="left">If you have entered everything correctly, the backup file should be sent to you once, otherwise there is a problem in this process and you can raise your problem from the issues</p>

<p align="left">You can check the mysql persistance volume location with command:</p>
  
```bash
docker volume inspect mysql
``` 
<p align="left">In my case:</p>
<p align="left">/var/lib/docker/volumes/mysql/_data
</p>

