# nixeko — handoff notes

## Current state

Self-contained. Should build cleanly on any x86_64 Intel+NVIDIA machine.
Run the VM build test before deploying to real hardware.

---

## Structure

### Hosts
- `hosts/nixeko/` — main host (hardware config is a placeholder, replaced on install)
- `hosts/nixeko-vm/` — QEMU test target, no NVIDIA, password `nixeko`

### System modules (`modules/system/`)
| File | Purpose |
|------|---------|
| `base.nix` | pipewire, docker, syncthing, tailscale, flatpak, bluetooth, zram |
| `security.nix` | kernel hardening, AppArmor, firewall |
| `nvidia.nix` | Intel + NVIDIA PRIME offload — bus IDs patched by install wizard |
| `networking.nix` | NetworkManager, systemd-resolved, Pi-hole DNS (127.0.0.1) |
| `services.nix` | cron, locate, avahi |
| `theme.nix` | Stylix, NES palette default, wallpaper: emerald-07.png |
| `vpn.nix` | Auto-loads all `vpn/configs/*.ovpn` as systemd openvpn services |

### Home modules (`home/`)
| File | Purpose |
|------|---------|
| `packages.nix` | User packages |
| `shell.nix` | bash, starship, alacritty, git, fzf, zoxide, lazygit |
| `hyprland.nix` | Hyprland + hypridle + hyprlock |
| `waybar.nix` | Status bar |
| `walker.nix` | Launcher + SearXNG websearch integration |
| `neovim.nix` | LazyVim bootstrap |
| `scripts.nix` | Menu scripts + Nautilus bookmarks |

### Docker services (`docker/`)
- **Pi-hole** — DNS ad blocker, web UI at `localhost:8080/admin`
- **SearXNG** — self-hosted search, web UI at `localhost:8888`

### VPN (`vpn/`)
Drop your `.ovpn` files in `vpn/configs/`, create `vpn/credentials` — see `vpn/README.md`.
Both are gitignored. nixeko rebuild picks them up automatically.

---

## Before you install

1. Read `TESTING.md` — build-test with `nixeko-vm` first
2. Edit `home/shell.nix` — set your git `userName` and `userEmail`
3. Edit `hosts/nixeko/default.nix` — set your `time.timeZone`
4. Add VPN configs to `vpn/configs/` (optional, can do post-install)

---

## Install

```bash
# Boot NixOS ISO, get internet, then:
nix-shell -p git
git clone https://github.com/IronDingo/nixeko
sudo bash nixeko/bin/nixeko-install
```

The wizard handles: hostname, partitioning, LUKS encryption, NVIDIA bus ID detection, hardware config generation, and nixos-install.

---

## First boot checklist

```bash
nixeko doctor                                            # health check
cd ~/Projects/nixeko/docker/pihole
cp .env.example .env                                     # set PIHOLE_PASSWORD
docker compose up -d
cd ../searxng && docker compose up -d
```

---

## CLI (`bin/nixeko`)

```
nixeko update           flake update + rebuild
nixeko rebuild          rebuild + switch
nixeko rollback         revert to previous generation
nixeko generations      list generations
nixeko theme <name>     switch base16 theme + rebuild
nixeko wallpaper <f>    switch wallpaper + rebuild
nixeko install <pkg>    add package + rebuild
nixeko remove <pkg>     remove package + rebuild
nixeko clean            garbage collect + optimise store
nixeko doctor           full system health check
nixeko rescue           recovery reference
```

---

## Keybinds

| Keybind | Action |
|---------|--------|
| Super+Return | Terminal (alacritty) |
| Super+Alt+Space | Walker launcher |
| Super+Q | Close window |
| Super+F | Fullscreen |
| Super+V | Float window |
| Super+Shift+B | Firefox |
| Super+Shift+N | Neovim |
| Super+Shift+O | Obsidian |
| Super+Shift+G | Signal |
| Super+Shift+M | Spotify |
| Super+Shift+T | btop |
| Super+Shift+D | Docker compose menu |
| Super+Shift+Ctrl+L | Lazydocker |
| Super+Shift+S | SearXNG (localhost:8888) |
| Super+Shift+H | Home server (192.168.1.107) |
| Super+Shift+F | Jellyfin (localhost:8096) |
| Super+Shift+A | DeepSeek |
| Super+Shift+Alt+A | Claude.ai |
| Super+Shift+Ctrl+A | Local LLM (Ollama + DeepSeek R1) |
| Super+Shift+E | Proton Mail |
| Super+Shift+C | Proton Calendar |
| Super+Shift+Y | YouTube |
| Super+Shift+Ctrl+D | Nebula |
| Super+Shift+Ctrl+F | Prime Video |
| Super+Shift+/ | 1Password |
| Super+Shift+Alt+S | Screenshot (region) |
| Super+Shift+Ctrl+V | VPN selector |
| Super+Shift+Ctrl+P | Pi-hole / SearXNG menu |
| Super+Shift+Ctrl+Q | Power menu |

---

## Themes

`nixeko theme <name>` — switches and rebuilds.

| Name | Palette |
|------|---------|
| `nes` | NES palette (default) |
| `catppuccin-mocha` | purple pastels |
| `gruvbox-dark-hard` | warm amber |
| `nord` | arctic blue |
| `tokyo-night-dark` | tokyo night |
| `rose-pine` | warm rose |
| `kanagawa` | japanese ink |
| `gameboy` | classic green |

---

## Rescue

```bash
nixeko rescue          # print recovery reference
nixeko rollback        # revert last change
nixeko generations     # list all generations
# Boot menu → Space → select previous generation
```
