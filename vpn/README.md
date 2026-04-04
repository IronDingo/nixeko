# VPN Setup

nixeko auto-loads every `.ovpn` file in this directory as a systemd service.
Switch between them with `Super+Shift+Ctrl+V` or `vpn-menu`.

## 1. Add your configs

Drop your `.ovpn` files into `vpn/configs/`:

```
vpn/configs/
  my-server-01.ovpn
  my-server-02.ovpn
  ...
```

Works with any OpenVPN provider. ProtonVPN users: download configs from
account.proton.me → VPN → Downloads → OpenVPN configuration files.

Strip these lines from each file if present — nixeko manages them:
```
auth-user-pass
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
```

## 2. Add your credentials

```bash
cp vpn/credentials.example vpn/credentials
# edit vpn/credentials with your username and password
```

For ProtonVPN the username/password are your **OpenVPN credentials**
(different from your account login) — found at account.proton.me → VPN → Downloads.

## 3. Rebuild

```bash
nixeko rebuild
```

Your configs are now registered as `openvpn-<filename>` systemd services.

## Usage

```bash
# Via keybind
Super+Shift+Ctrl+V      # opens VPN selector menu

# Via CLI
sudo systemctl start openvpn-my-server-01
sudo systemctl stop  openvpn-my-server-01
sudo systemctl status openvpn-my-server-01
```

## Note

`vpn/configs/` and `vpn/credentials` are gitignored — your configs stay local.
