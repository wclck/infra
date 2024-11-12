### Diagram Explanation:

1. **Management Server (mngmt)**: Manages user configurations and settings, writes user data to **MySQL**, and backs up information to Telegram.
2. **MySQL Database**: Central data storage for all user information and configurations, hosted on the **Management Server**.
3. **Subscription Server (podpiska)**: Reads user data from **MySQL** to provide subscription links.
4. **Proxy Server (go)**: Simply distributes incoming connections from end-users across the **Marzban Worker Servers** via **HAProxy**.
5. **Marzban Worker Servers**: Retrieve configurations from **MySQL** and handle user connections routed through the **Proxy Server**.

This layout shows the **Management Server** as the central point of control, with all other servers relying on the database it manages.
