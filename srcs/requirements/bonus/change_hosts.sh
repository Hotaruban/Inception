#!/bin/bash

HOST_FILE="/etc/hosts"

LOCALHOST_LINE="127.0.0.1 localhost"
JHOST_LINE="127.0.0.1 jhurpy.42.fr"

comment_line() {
        sed -i "s/^\($1\)/#\1/" "$HOST_FILE"
}

uncomment_line() {
        sed -i "s/^#\($1\)/\1/" "$HOST_FILE"
}

if ! grep -q "^#\($JHOST_LINE\)\|^$JHOST_LINE" "$HOST_FILE"; then
        echo "$JHOST_LINE" >> "$HOST_FILE"
fi

if grep -q "^#\($LOCALHOST_LINE\)" "$HOST_FILE"; then
        uncomment_line "$LOCALHOST_LINE"
        if grep -q "^$JHOST_LINE" "$HOST_FILE"; then
                comment_line "$JHOST_LINE"
        fi
elif grep -q "^$LOCALHOST_LINE" "$HOST_FILE"; then
        comment_line "$LOCALHOST_LINE"
        if grep -q "^#\($JHOST_LINE\)" "$HOST_FILE"; then
                uncomment_line "$JHOST_LINE"
        fi
fi

cat "$HOST_FILE"


# This script is used to change the hosts file of the system.
# It adds the line for the jhurpy.42.fr domain and comments the localhost line.
# If the localhost line is commented, it will uncomment it and comment the jhurpy line.
# At the end, it will display the content of the hosts file.
