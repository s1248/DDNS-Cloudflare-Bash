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


# Move the configuration file to the same directory as the script
sudo mv update-cloudflare-dns.conf /usr/local/bin/update-cloudflare-dns.conf

# Run the update script to check if it's working
/usr/local/bin/update-cloudflare-dns

# Add a cron job to run the script every minute
(crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/update-cloudflare-dns") | crontab -
