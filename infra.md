```mermaid
flowchart TD
    %% Cloudflare DNS Resolution
    Cloudflare["Cloudflare DNS"] --> go["Proxy Server go.weclick.tech"]
    Cloudflare --> mngmt["Management Server mngmt.weclick.tech"]
    Cloudflare --> podpiska["Subscription Server podpiska.weclick.tech"]

    %% Proxy Server (go.weclick.tech) distributes connections through HAProxy
    go --> HAProxy[HAProxy Load Balancer]

    %% Marzban Servers behind HAProxy
    HAProxy --> srv1[Marzban Server 1 - srv1.weclick.tech]
    HAProxy --> srv2[Marzban Server 2 - srv2.weclick.tech]
    HAProxy --> srvN[Marzban Server N - srvN.weclick.tech]

    %% Management Server with MySQL Database and Telegram Backup
    mngmt --> MySQL[(MySQL Database in Docker on mngmt)]
    mngmt --> Telegram["Backup to Telegram"]

    %% Subscription Server connected to MySQL on Management Server
    podpiska --> MySQL

    %% Marzban Servers connected to the same MySQL Database
    srv1 --> MySQL
    srv2 --> MySQL
    srvN --> MySQL

    %% Notes and Connections
    mngmt -.-> MySQL[db.weclick.tech] 
    podpiska -.-> MySQL[db.weclick.tech] 
