```mermaid
flowchart TD
    Cloudflare["Cloudflare DNS (Service)"]

    go["Proxy Server go.weclick.tech (User VPN Connections)"]
    podpiska["Subscription Server podpiska.weclick.tech (Check Subscription)"]

    mngmt["Management Server mngmt.weclick.tech (Configuration & User Management)"]
    mngmt --> |"Writes user data to"| MySQL[(MySQL Database)]
    mngmt --> |"Backups"| Telegram["Backup to Telegram"]
    MySQL --> Telegram

    go --> HAProxy[HAProxy Load Balancer]

    HAProxy --> srv1[Marzban Worker Server 1 - srv1.weclick.tech]
    HAProxy --> srv2[Marzban Worker Server 2 - srv2.weclick.tech]
    HAProxy --> srvN[Marzban Worker Server N - srvN.weclick.tech]

    podpiska --> |"Reads user data from"| MySQL

    srv1 --> |"Reads configuration from"| MySQL
    srv1 --> |"Writes traffic usage stats to"| MySQL
    srv2 --> |"Reads configuration from"| MySQL
    srv2 --> |"Writes traffic usage stats to"| MySQL
    srvN --> |"Reads configuration from"| MySQL
    srvN --> |"Writes traffic usage stats to"| MySQL

    Cloudflare -.-> mngmt
    Cloudflare -.-> podpiska
    Cloudflare -.-> go
    Cloudflare -.-> MySQL

    user["User"] --> go
    user --> podpiska
