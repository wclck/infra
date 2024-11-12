### Explanation of the Mermaid Code Structure:

1. **DNS Node** – Cloudflare directs domain names to their respective servers, including the proxy, management, and subscription servers.
2. **Proxy Server (go.weclick.tech)** routes traffic through **HAProxy** to the Marzban servers.
3. **Management Server** (mngmt.weclick.tech) is connected to the MySQL database and performs backups to Telegram.
4. **Subscription Server** (podpiska.weclick.tech) also connects to the same MySQL database.
5. **Marzban Servers** are connected to HAProxy and share a single MySQL database hosted on the management server.
