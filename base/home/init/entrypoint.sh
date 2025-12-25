#!/bin/bash

# Add SSH public key if provided and authorized_keys is empty
if [ -n "$SSH_PUBKEY" ] && [ ! -s ~/.ssh/authorized_keys ]; then
    echo "$SSH_PUBKEY" > ~/.ssh/authorized_keys
fi

# Start SSH server if enabled
if [ "$SSH_START" = "true" ]; then
    sudo service ssh start
fi

# Execute the main command
exec "$@"
