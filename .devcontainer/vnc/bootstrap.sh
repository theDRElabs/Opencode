#!/usr/bin/env bash
set -u

log() { echo "[vnc-bootstrap] $*" >> /tmp/vnc-bootstrap.log; }

# ---------------------------------------------------------------------------
# Tailnet SSH access (phone -> codespace over Tailscale)
# ---------------------------------------------------------------------------

# Install the phone's public key so key-based SSH works over the tailnet.
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
KEYS_SRC="/workspaces/Opencode/.devcontainer/ssh/authorized_keys"
if [ -f "$KEYS_SRC" ]; then
  touch "$HOME/.ssh/authorized_keys" && chmod 600 "$HOME/.ssh/authorized_keys"
  while IFS= read -r key; do
    [ -z "$key" ] && continue
    grep -qF "$key" "$HOME/.ssh/authorized_keys" || echo "$key" >> "$HOME/.ssh/authorized_keys"
  done < "$KEYS_SRC"
fi

# Harden sshd: key + password auth over the tailnet.
sudo tee /etc/ssh/sshd_config.d/99-tailnet-hardening.conf >/dev/null <<'SSHD_EOF'
PubkeyAuthentication yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
UsePAM yes
PermitRootLogin prohibit-password
SSHD_EOF
if sudo sshd -t 2>/dev/null; then
  sudo pkill -HUP -x sshd 2>/dev/null || sudo kill -HUP "$(cat /run/sshd.pid 2>/dev/null)" 2>/dev/null || true
else
  log "sshd config invalid; not reloading"
fi

# Ensure a TUN device exists (the container device node is ephemeral)
if [ ! -c /dev/net/tun ]; then
  sudo mkdir -p /dev/net 2>/dev/null
  sudo mknod /dev/net/tun c 10 200 2>/dev/null || true
  sudo chmod 666 /dev/net/tun 2>/dev/null || true
fi

# Start tailscaled if not already running
if ! pgrep -x tailscaled >/dev/null; then
  sudo mkdir -p /var/lib/tailscale /var/run/tailscale
  nohup sudo setsid tailscaled \
    --state=/var/lib/tailscale/tailscaled.state \
    --socket=/var/run/tailscale/tailscaled.sock \
    >/tmp/tailscaled.log 2>&1 &
  for _ in $(seq 1 30); do
    [ -S /var/run/tailscale/tailscaled.sock ] && break
    sleep 1
  done
fi

# Bring the node up using the persisted, already-authorized state.
# Same hostname as the initial login so restarts rejoin the same node.
export TS_SOCKET=/var/run/tailscale/tailscaled.sock
sudo timeout 20 tailscale up --hostname=codespace-opencode --ssh --accept-dns=false >>/tmp/vnc-bootstrap.log 2>&1 || \
  log "tailscale up failed (see /tmp/tailscale-up.log); rerun login: export TS_SOCKET=/var/run/tailscale/tailscaled.sock && sudo tailscale up"

# (Re)start the VNC server
vncserver -kill :1 >/dev/null 2>&1 || true
sleep 1
vncserver :1 -geometry 1280x720 -depth 24 -localhost=no >>/tmp/vnc-bootstrap.log 2>&1 || \
  log "vncserver start failed (see /tmp/vnc-bootstrap.log)"

log "done"