#!/bin/sh

pkill -f autossh
pkill -f parallel

export AUTOSSH_LOGFILE="/logs/autossh.log"
export AUTOSSH_LOGLEVEL="7"

parallel -j 100 --verbose -u autossh -M 0 -o \"ExitOnForwardFailure yes\" -o \"StrictHostKeyChecking no\" -o \"ServerAliveInterval 30\" -o \"ServerAliveCountMax 3\" -NR {} $REMOTE_USER@$HOST -E /logs/ssh.log -v -i /ssh/id_rsa </tunnels &
