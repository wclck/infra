```mermaid
flowchart TD
    %% Cloudflare DNS Resolution
    Cloudflare["Cloudflare DNS"] --> go["Proxy Server go.weclick.tech"]

    %% Management Server
    mngmt["Management Server mngmt.weclick.tech (Configuration & User Management)"]
    mngmt --> |"Writes user data to"| MySQL[(MySQL Database on mngmt)]
    mngmt --> |"Backups"| Telegram["Backup to Telegram"]

    %% Proxy Server distributing connections
    go --> |"Distributes incoming connections"| HAProxy[HAProxy Load Balancer]

    %% Marzban Worker Servers
    HAProxy --> srv1[Marzban Worker Server 1 - srv1.weclick.tech]
    HAProxy --> srv2[Marzban Worker Server 2 - srv2.weclick.tech]
    HAProxy --> srvN[Marzban Worker Server N - srvN.weclick.tech]

    %% Subscription Server reading user data from MySQL
    podpiska["Subscription Server podpiska.weclick.tech (Provides Subscription Links)"]
    podpiska --> |"Reads user data from"| MySQL

    %% Worker Servers reading configuration from MySQL
    srv1 --> |"Reads configuration from"| MySQL
    srv2 --> |"Reads configuration from"| MySQL
    srvN --> |"Reads configuration from"| MySQL

    %% DNS Resolution Connections
    Cloudflare -.-> mngmt
    Cloudflare -.-> podpiska
