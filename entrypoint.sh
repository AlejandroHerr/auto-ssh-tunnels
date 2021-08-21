# !/bin/bash

if [[ -z "${REMOTE_USER}" ]]; then
  echo "[ERROR] REMOTE_USER not set!"
  exit 1
fi

if [[ -z "${HOST}" ]]; then
  echo "[ERROR] HOST not set!"
  exit 1
fi

/startTunnels.sh

/usr/local/bin/docker-gen -config /docker-gen.cfg
