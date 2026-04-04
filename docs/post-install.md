# Post-install checklist

Everything that needs doing after the install wizard finishes and you boot into nixeko.

---

## 1. Health check

```bash
nixeko doctor
```

Fix anything red before moving on.

---

## 2. Set your password

```bash
passwd
```

---

## 3. Git identity

Edit `~/Projects/nixeko/home/shell.nix` — set your name and email:

```nix
userName  = "your-github-username";
userEmail = "you@example.com";
```

Then:
```bash
nixeko rebuild
```

---

## 4. Start Docker services

```bash
# Pi-hole
cd ~/Projects/nixeko/docker/pihole
cp .env.example .env
nvim .env                  # set PIHOLE_PASSWORD
docker compose up -d

# SearXNG
cd ~/Projects/nixeko/docker/searxng
docker compose up -d
```

Verify:
- Pi-hole → localhost:8080/admin
- SearXNG → localhost:8888

---

## 5. VPN

See `docs/vpn.md` for the full guide. Quick version:

```bash
cp /your/backup/*.ovpn ~/Projects/nixeko/vpn/configs/
cp /your/backup/credentials ~/Projects/nixeko/vpn/credentials
nixeko rebuild
# Then: Super+Shift+Ctrl+V to connect
```

---

## 6. Tailscale

```bash
sudo tailscale up
```

---

## 7. SSH key

```bash
ssh-keygen -t ed25519 -C "you@example.com"
cat ~/.ssh/id_ed25519.pub   # add to github.com/settings/keys
```

---

## 8. Syncthing

Open browser → localhost:8384 (or check `systemctl status syncthing`)
Add your devices and sync folders.

---

## 9. Neovim

First launch downloads all plugins (needs internet):

```bash
nvim
```

Wait for lazy.nvim to finish installing. LSPs install on first file open.

---

## 10. Theme (optional)

```bash
nixeko theme catppuccin-mocha   # or any name from: nixeko help
```

---

## Useful first commands

```bash
nixeko doctor          # full health check
nixeko rescue          # recovery reference card
nixeko theme <name>    # switch color palette
nixeko wallpaper <f>   # switch wallpaper
```
