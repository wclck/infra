# Usage

First you need to copy [html file](https://raw.githubusercontent.com/wclck/infra/refs/heads/main/sub-page/index.html) to your sever. You can do it by this:

```bash
cd /opt/marzban
apt install wget
wget -O index.html https://raw.githubusercontent.com/wclck/infra/refs/heads/main/sub-page/index.html?token=GHSAT0AAAAAAC26KCQN22R47NRB7OHVNJRKZ2PKYTA
```

Then you have to map it to your docker container. Add this line to volume section of `docker-compose.yml`:

(DO NOT REPLACE WHOLE FILE, Just the last line)
```docker
services:
    marzban:
        ...
        volumes:
            ...
            - /opt/marzban/index.html:/code/app/templates/subscription/index.html # this line
```

Now you can restart your marzban's docker:
```
marzban restart
```

# Edit

You can change default settings from settings variable in index.html, [here](https://github.com/wclck/infra/blob/6ea7a078837c01da9370e25f78f722170847a6e4/sub-page/index.html#L194) line 194

You can also change tutorial from appsJson variable in index.html, [here](https://github.com/wclck/infra/blob/6ea7a078837c01da9370e25f78f722170847a6e4/sub-page/index.html#L25) line 25

For tutorial video, you need to set direct link of video to tutorial of json

To change logo you can change src in line 226
