```mermaid
flowchart TD
    %% Cloudflare DNS Resolution (Service only)
    Cloudflare["Cloudflare DNS (Service)"]

    %% Proxy Server (Entry Point)
    go["Proxy Server go.weclick.tech (User VPN Connections)"]

    %% Management Server (Configuration & User Management)
    mngmt["Management Server mngmt.weclick.tech (Configuration & User Management)"]
    mngmt --> |"Writes user data to"| MySQL[(MySQL Database on mngmt)]
    mngmt --> |"Backups"| Telegram["Backup to Telegram"]

    %% Proxy Server distributing connections
    go --> HAProxy[HAProxy Load Balancer]

    %% Marzban Worker Servers
    HAProxy --> srv1[Marzban Worker Server 1 - srv1.weclick.tech]
    HAProxy --> srv2[Marzban Worker Server 2 - srv2.weclick.tech]
    HAProxy --> srvN[Marzban Worker Server N - srvN.weclick.tech]

    %% Subscription Server reading user data from MySQL
    podpiska["Subscription Server podpiska.weclick.tech (Provides Subscription Links)"]
    podpiska --> |"Reads user data from"| MySQL

    %% Worker Servers reading configuration from MySQL and writing traffic stats
    srv1 --> |"Reads configuration from"| MySQL
    srv1 --> |"Writes traffic usage stats to"| MySQL
    srv2 --> |"Reads configuration from"| MySQL
    srv2 --> |"Writes traffic usage stats to"| MySQL
    srvN --> |"Reads configuration from"| MySQL
    srvN --> |"Writes traffic usage stats to"| MySQL

    %% DNS Resolution Connections (Cloudflare as a service)
    Cloudflare -.-> mngmt
    Cloudflare -.-> podpiska
    Cloudflare -.-> go
    Cloudflare -.-> db
