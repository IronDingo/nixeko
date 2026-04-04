# nixeko

A self-contained NixOS configuration. Clone it, run the installer, get a complete system.

Hyprland. Stylix theming. ProtonVPN. Pi-hole. SearXNG. One CLI to manage it all.

---

## Stack

| Layer | Choice |
|---|---|
| OS | NixOS unstable |
| WM | Hyprland |
| Bar | Waybar |
| Launcher | Walker |
| Terminal | Alacritty |
| Editor | Neovim (LazyVim) + Sublime Text 4 |
| Shell | Bash + Starship |
| Theming | Stylix (base16) |
| DNS | Pi-hole (Docker) |
| Search | SearXNG (Docker, localhost:8888) |
| VPN | ProtonVPN via OpenVPN |
| Mesh | Tailscale |
| Sync | Syncthing |

---

## Forking

nixeko uses `eko` as the username throughout. Before installing as your own:

1. Rename `home/eko.nix` to `home/<yourname>.nix`
2. Update `flake.nix` — change `users.eko` and the import path
3. Update `hosts/nixeko/default.nix` — change `users.users.eko` and the `polkitPolicyOwners`
4. Set your git identity in `home/shell.nix`
5. Set your timezone in `hosts/nixeko/default.nix`

Or just leave `eko` — it's a username, not an identity.

---

## Install

Boot a NixOS installer USB, then:

```bash
nix-shell -p git
git clone https://github.com/IronDingo/nixeko
sudo bash nixeko/bin/nixeko-install
```

The wizard handles partitioning, LUKS encryption, NVIDIA detection, and first boot setup. Name your ship.

---

## CLI

```bash
nixeko update          # flake update + rebuild
nixeko rebuild         # rebuild and switch
nixeko rollback        # revert to previous generation
nixeko generations     # list all generations

nixeko theme <name>    # switch base16 theme + rebuild
nixeko wallpaper <f>   # switch wallpaper + rebuild
nixeko install <pkg>   # add package + rebuild
nixeko remove <pkg>    # remove package + rebuild

nixeko doctor          # full system health check
nixeko rescue          # recovery reference
```

---

## Themes

Switch with `nixeko theme <name>`:

| Name | Palette |
|---|---|
| `nes` | NES palette (default) |
| `catppuccin-mocha` | purple pastels |
| `gruvbox-dark-hard` | warm amber |
| `nord` | arctic blue |
| `tokyo-night-dark` | tokyo night |
| `rose-pine` | warm rose |
| `kanagawa` | japanese ink |
| `gameboy` | classic green |

---

## Key bindings

| Keys | Action |
|---|---|
| Super+Alt+Space | Walker launcher |
| Super+Return | Terminal |
| Super+Shift+B | Firefox |
| Super+Shift+N | Neovim |
| Super+Shift+O | Obsidian |
| Super+Shift+G | Signal |
| Super+Shift+M | Spotify |
| Super+Shift+T | btop |
| Super+Shift+D | Lazydocker |
| Super+Shift+A | DeepSeek |
| Super+Shift+Alt+A | Claude AI |
| Super+Shift+Ctrl+A | Local LLM (Ollama) |
| Super+Shift+E | Proton Mail |
| Super+Shift+C | Proton Calendar |
| Super+Shift+/ | 1Password |
| Super+Shift+Alt+S | Screenshot (region) |
| Super+Shift+Ctrl+V | VPN selector |
| Super+Shift+Ctrl+P | Pi-hole / SearXNG |
| Super+Shift+Ctrl+Q | Power menu |

---

## Structure

```
nixeko/
├── flake.nix                   # inputs + host definitions
├── bin/
│   ├── nixeko                  # management CLI
│   └── nixeko-install          # install wizard
├── hosts/
│   ├── nixeko/                 # main host (auto-generated hardware config)
│   └── nixeko-vm/              # QEMU test host
├── modules/system/
│   ├── base.nix                # audio, fonts, docker, syncthing
│   ├── theme.nix               # Stylix + wallpaper
│   ├── nvidia.nix              # Intel + NVIDIA PRIME offload
│   ├── networking.nix          # NetworkManager, DNS-over-TLS, Pi-hole
│   ├── security.nix            # firewall, AppArmor, polkit
│   ├── services.nix            # system services
│   └── vpn.nix                 # ProtonVPN (auto-loads vpn/configs/*.ovpn)
├── home/
│   ├── packages.nix            # user packages
│   ├── shell.nix               # bash, starship, alacritty, git, fzf, zoxide
│   ├── hyprland.nix            # hyprland + hypridle + hyprlock
│   ├── waybar.nix              # status bar
│   ├── walker.nix              # launcher + SearXNG integration
│   ├── neovim.nix              # LazyVim bootstrap
│   └── scripts.nix             # menus, Nautilus bookmarks
├── docker/
│   ├── pihole/                 # Pi-hole compose
│   └── searxng/                # SearXNG compose + settings
├── vpn/
│   ├── configs/                # normalized ProtonVPN ovpn files
│   └── credentials             # ProtonVPN login
└── wallpapers/                 # 24 retro wallpapers
```

---

## After first boot

```bash
# Start Docker services
cd ~/Projects/nixeko/docker/pihole  && cp .env.example .env  # set PIHOLE_PASSWORD
cd ~/Projects/nixeko/docker/searxng && docker compose up -d
cd ~/Projects/nixeko/docker/pihole  && docker compose up -d

# Connect VPN
nixeko doctor   # check everything is healthy
```

---

## Docs

- [TESTING.md](TESTING.md) — validate in a VM before deploying to real hardware
- [docs/post-install.md](docs/post-install.md) — everything to do after first boot
- [docs/vpn.md](docs/vpn.md) — VPN setup, backup, and reinstall guide
