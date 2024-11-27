#!/bin/bash

# --- Configuration Variables ---
# Bot token and chat IDs setup
BOT_TOKEN=""
CHAT_IDS=()  # Multiple chat IDs, initialized as an empty array
CAPTION=""
CRON_TIME="0 0 * * *"  # Default cron job for 12 AM daily

# Paths
MARZBAN_DIR="/opt/marzban"
BACKUP_DIR="/var/lib/marzban"
SCRIPT_DIR="/root"
SERVER_BACKUP_FILE=""  # This will be dynamically set later
BACKUP_SCRIPT="$SCRIPT_DIR/server-backup.sh"

# --- Functions ---
# Function to trim leading/trailing whitespaces
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"  # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"  # remove trailing whitespace characters
    echo -n "$var"
}

# --- Step 1: Collect User Input ---
# Bot token
while [[ -z "$BOT_TOKEN" ]]; do
    echo "Enter your Telegram bot token: "
    read -r BOT_TOKEN
    if [[ $BOT_TOKEN == $'\0' ]]; then
        echo "Invalid input. Token cannot be empty."
        unset BOT_TOKEN
    fi
done

# Chat IDs
while true; do
    echo "Enter the number of Telegram chat IDs: "
    read -r NUM_IDS
    if [[ ! "$NUM_IDS" =~ ^[0-9]+$ ]] || [[ "$NUM_IDS" -le 0 ]]; then
        echo "Invalid number. Please enter a positive integer."
    else
        break
    fi
done

# Collecting chat IDs
for ((i=1; i<=NUM_IDS; i++)); do
    while true; do
        echo "Enter Telegram chat ID #$i: "
        read -r CHAT_ID
        if [[ -z "$CHAT_ID" ]]; then
            echo "Chat ID cannot be empty. Please enter a valid ID."
        else
            CHAT_IDS+=("$CHAT_ID")
            break
        fi
    done
done

# Caption
echo "Caption (for example, your domain, to identify the database file more easily): "
read -r caption

# Trim any unnecessary spaces from the caption
CAPTION=$(trim "$caption")

# Ensure caption is set (default if empty)
if [[ -z "$CAPTION" ]]; then
    CAPTION="default-caption"
    echo "No caption entered, using default caption: $CAPTION"
fi


# --- Step 2: Cron Job Setup ---
# Check if user wants to clear previous cron jobs
while [[ -z "$CRONTABS" ]]; do
    echo "Would you like the previous crontabs to be cleared? [y/n] : "
    read -r CRONTABS
    if [[ $CRONTABS == $'\0' ]]; then
        echo "Invalid input. Please choose y or n."
        unset CRONTABS
    elif [[ ! $CRONTABS =~ ^[yn]$ ]]; then
        echo "${CRONTABS} is not a valid option. Please choose y or n."
        unset CRONTABS
    fi
done

# Remove previous cronjobs if necessary
if [[ "$CRONTABS" == "y" ]]; then
    echo "Deleting previous cron jobs related to the backup..."
    sudo crontab -l | grep -vE '/root/server-backup.+\.sh' | crontab -
    echo "Previous cron jobs related to the backup deleted."
fi

# --- Step 3: Backup Preparation ---
# Check if Marzban directory exists
if [ ! -d "$MARZBAN_DIR" ]; then
    echo "The folder does not exist: $MARZBAN_DIR"
    exit 1
else
    echo "The folder exists: $MARZBAN_DIR"
fi

# --- Step 4: Create `server-backup.sh` file ---
echo "Creating backup script: $BACKUP_SCRIPT"

cat > "$BACKUP_SCRIPT" << EOL
#!/bin/bash

# Backup paths
MARZBAN_DIR="$MARZBAN_DIR"
BACKUP_DIR="$BACKUP_DIR"
SERVER_BACKUP_FILE="$SERVER_BACKUP_FILE"
BOT_TOKEN="$BOT_TOKEN"
CAPTION="$CAPTION"
CHAT_IDS="${CHAT_IDS[@]}"

# Step 2: Create Backup Zip
echo "Creating backup zip..."
BACKUP_FILE="\$CAPTION-backup-\$(date +%Y-%m-%d).zip"
rm -rf "\$BACKUP_FILE"
zip -r "\$BACKUP_FILE" "\$MARZBAN_DIR"/* "\$BACKUP_DIR"/* "\$MARZBAN_DIR/.env"

# Step 3: Send Backup to Telegram
SERVER_IP=\$(hostname -I | awk '{print \$1}')
CAPTION_MESSAGE="\$CAPTION - \$SERVER_IP"

# Send the backup to each chat ID
for CHAT_ID in \${CHAT_IDS[@]}; do
    curl -F chat_id="\$CHAT_ID" -F caption="\$CAPTION_MESSAGE\" -F parse_mode="HTML" -F document=@"\$BACKUP_FILE" "https://api.telegram.org/bot\$BOT_TOKEN/sendDocument"
done

EOL

# Make the backup script executable
chmod +x "$BACKUP_SCRIPT"

# --- Step 5: Set Cron Job ---
# Add cron job for daily backup at 12 AM
{ crontab -l -u root; echo "$CRON_TIME /bin/bash $BACKUP_SCRIPT >/dev/null 2>&1"; } | crontab -u root -

# --- Step 6: Execute `server-backup.sh` ---
echo "Executing the backup script now..."
/bin/bash "$BACKUP_SCRIPT"

# --- Done ---
echo -e "\nBackup process completed. Cron job set for daily backup at 12 AM."
