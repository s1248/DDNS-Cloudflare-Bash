#!/bin/bash

# Update the package list
sudo apt update -y

# Install cron if it's not already installed
sudo apt install cron -y

# Enable and start the cron service
sudo systemctl enable cron
sudo systemctl start cron

# Download the Cloudflare DDNS update script
wget https://raw.githubusercontent.com/s1248/DDNS-Cloudflare-Bash/main/update-cloudflare-dns.sh

# Make the script executable
sudo chmod +x update-cloudflare-dns.sh

# Move the script to a directory in the PATH
sudo mv update-cloudflare-dns.sh /usr/local/bin/update-cloudflare-dns

# Download the default configuration file for the script
wget https://raw.githubusercontent.com/s1248/DDNS-Cloudflare-Bash/main/update-cloudflare-dns.conf

# Replace the contents of the configuration file with the provided details
cat > update-cloudflare-dns.conf <<EOL
##### Config

## Which IP should be used for the record: internal/external
## Internal interface will be chosen automaticly as a primary default interface
what_ip="internal"

## DNS A record to be updated, you can separate multiple records by comma
dns_record="ddns.example.com,ddns2.example.com"

## Cloudflare's Zone ID, you can find this on the landing/overview page of your domain.
zoneid="ChangeMe"

## Cloudflare Zone API Token
cloudflare_zone_api_token="ChangeMe"

## Use Cloudflare proxy on dns record true/false
proxied="false"

## 120-7200 in seconds or 1 for Auto
ttl=120

## Telegram Notifications yes/no (only sent if DNS is updated)
notify_me_telegram="no"

## Telegram Chat ID
telegram_chat_id="ChangeMe"

## Telegram Bot API Key
telegram_bot_API_Token="ChangeMe"


EOL

# Move the configuration file to the same directory as the script
sudo mv update-cloudflare-dns.conf /usr/local/bin/update-cloudflare-dns.conf

# Run the update script to check if it's working
/usr/local/bin/update-cloudflare-dns

# Add a cron job to run the script every minute
(crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/update-cloudflare-dns") | crontab -
