#!/usr/bin/env bash

echo "installing latest version of aerobatic-cli"

# Download and unpack the latest version of the aeroatic cli
aws s3 cp s3://aerobatic-media/downloads/aerobatic-cli/latest.tar.gz /tmp/aerobatic-cli.tar.gz
sudo mkdir /var/lib/aerobatic-cli
sudo tar -xf /tmp/aerobatic-cli.tar.gz -C /var/lib/aerobatic-cli

# Grant execute access to the executable file
sudo chmod 751 /var/lib/aerobatic-cli/bin/aerobatic.js

# Symlink it to into the PATH
sudo ln -s /var/lib/aerobatic-cli/bin/aerobatic.js /usr/local/bin/aerobatic
