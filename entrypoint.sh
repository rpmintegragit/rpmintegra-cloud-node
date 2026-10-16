#!/bin/bash
set -e

mkdir -p /data/.gemini /data/.hermes /data/workspaces /data/.ssh /data/logs
chmod 700 /data/.ssh

rm -rf /root/.gemini /root/.hermes
ln -sfn /data/.gemini /root/.gemini
ln -sfn /data/.hermes /root/.hermes

if [ ! -f /data/.ssh/ssh_host_ed25519_key ]; then
    ssh-keygen -t ed25519 -f /data/.ssh/ssh_host_ed25519_key -N ""
fi
if [ ! -f /data/.ssh/ssh_host_rsa_key ]; then
    ssh-keygen -t rsa -b 4096 -f /data/.ssh/ssh_host_rsa_key -N ""
fi
cp /data/.ssh/ssh_host_* /etc/ssh/ 2>/dev/null || true

if [ ! -f /data/.ssh/authorized_keys ]; then
    cp /root/.ssh/authorized_keys /data/.ssh/authorized_keys
fi
cp /data/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "=== RPM Integra Cloud Node Iniciado com Sucesso ==="
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf