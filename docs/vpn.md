# VPN — full guide

## How it works

Every `.ovpn` file you drop in `vpn/configs/` is automatically registered as a
systemd service on the next `nixeko rebuild`. No manual config. No editing nix files.

Your credentials live in `vpn/credentials` — two lines, username then password.

Both are **gitignored**. They live on your machine only. If you wipe the machine,
you need to restore them. That's what this doc is for.

---

## First-time setup

```bash
# 1. Add your .ovpn files
cp /wherever/your/configs/*.ovpn ~/Projects/nixeko/vpn/configs/

# 2. Add credentials
cp ~/Projects/nixeko/vpn/credentials.example ~/Projects/nixeko/vpn/credentials
nvim ~/Projects/nixeko/vpn/credentials   # two lines: username, then password

# 3. Rebuild
nixeko rebuild

# 4. Use it
Super+Shift+Ctrl+V    # VPN selector menu
```

For ProtonVPN — your OpenVPN credentials are **not** your account password.
Find them at: account.proton.me → VPN → Downloads → OpenVPN / IKEv2 credentials.

---

## After a reinstall

Your `.ovpn` files and credentials are **not in the git repo**. You need to restore them.

**Option A — from Syncthing**
If you backed up `vpn/configs/` and `vpn/credentials` to Syncthing before wiping:
```bash
cp ~/Syncthing-Master/nixeko-vpn/*.ovpn ~/Projects/nixeko/vpn/configs/
cp ~/Syncthing-Master/nixeko-vpn/credentials ~/Projects/nixeko/vpn/credentials
nixeko rebuild
```

**Option B — from USB**
```bash
cp /run/media/eko/BACKUP/vpn-configs/*.ovpn ~/Projects/nixeko/vpn/configs/
cp /run/media/eko/BACKUP/vpn-credentials    ~/Projects/nixeko/vpn/credentials
nixeko rebuild
```

**Option C — from ProtonVPN (fresh download)**
1. Go to account.proton.me → VPN → Downloads → OpenVPN configuration files
2. Download the configs you want, drop them in `vpn/configs/`
3. Get your OpenVPN credentials from the same page
4. Write them to `vpn/credentials` (username on line 1, password on line 2)
5. `nixeko rebuild`

---

## Backup recommendation

Before wiping a machine, back up these two things:

```bash
# Copy to Syncthing (or USB)
mkdir -p ~/Syncthing-Master/nixeko-vpn
cp ~/Projects/nixeko/vpn/configs/*.ovpn ~/Syncthing-Master/nixeko-vpn/
cp ~/Projects/nixeko/vpn/credentials    ~/Syncthing-Master/nixeko-vpn/
```

---

## Managing connections

```bash
# Via menu (recommended)
Super+Shift+Ctrl+V

# Via CLI
sudo systemctl start   openvpn-ch-951-systemd-fix
sudo systemctl stop    openvpn-ch-951-systemd-fix
sudo systemctl status  openvpn-ch-951-systemd-fix

# See all available VPN services
systemctl list-units 'openvpn-*' --all
```

---

## Troubleshooting

**VPN connects but no internet**
```bash
journalctl -u openvpn-<name> -n 50
# Look for DNS or routing errors
```

**Authentication failed**
```bash
cat ~/Projects/nixeko/vpn/credentials
# Make sure it's exactly: username on line 1, password on line 2, no extra spaces
```

**Service not found after adding new .ovpn**
```bash
nixeko rebuild   # vpn.nix re-reads vpn/configs/ on every rebuild
```

**Check what's deployed**
```bash
systemctl list-units 'openvpn-*' --all --no-legend
```

---

## Stripping configs (for new .ovpn files that don't work)

nixeko manages DNS and credentials itself. If a new `.ovpn` file has these lines,
remove them — they conflict:

```
auth-user-pass          ← remove (nixeko adds this pointing to your credentials)
up /etc/openvpn/...     ← remove (nixeko handles DNS via updateResolvConf)
down /etc/openvpn/...   ← remove
dhcp-option DNS ...     ← remove (nixeko sets its own)
```
