# nixeko — handoff notes

## Current state (2026-04-05)

**Installer is functional through step XVI (ignition) but has not completed a full install yet.**
Each VM test run has surfaced one new eval error. All known eval errors are now fixed.
The next run should either succeed or surface a build-time package error.

---

## What works

- Installer wizard: all steps through XVII complete without crashing
- Partitioning, LUKS, filesystem formatting, repo copy, hardware scan, flake patching
- Progress bar, Roman numeral headers, spinners on long ops, farewell summary table
- NES color scheme (ANSI) throughout installer UI
- Error handler: per-step diagnostics + retry commands + last 20 log lines

---

## Eval errors fixed this session (in order they appeared)

| # | Error | Fix |
|---|-------|-----|
| 1 | `path:` flake fetcher — Nix assertion crash (narHash mismatch) | Use `git add -A` before `nixos-install` so git fetcher sees staged files |
| 2 | `nur.nixosModules.nur` — attribute missing at NUR revision | Removed NUR entirely (nothing in the config used it) |
| 3 | `services.resolved.dns` — option removed in nixpkgs-unstable | Moved to `extraConfig` with resolved.conf syntax |
| 4 | `nes.yaml` — not in `base16-schemes` package | Bundled `themes/nes.yaml` in repo, reference via relative path |

---

## Simplifications made this session

- **Pi-hole DNS** removed from networking.nix (Docker isn't running at install time; 127.0.0.1 breaks DNS during install). Uses Cloudflare/Quad9 now.
- **vpn.nix** stripped from a complex eval-time `.ovpn` file reader to just `environment.systemPackages = [ pkgs.openvpn ]`. VPN setup is post-install.
- **Installer VPN step removed** — the wizard no longer asks about VPN configs. Steps renumbered I–XVII (was I–XVIII).

---

## Structure

### Hosts
- `hosts/nixeko/` — main host (hardware-configuration.nix is a placeholder, replaced on install)
- `hosts/nixeko-vm/` — QEMU test target, no NVIDIA, initialPassword `nixeko`

### System modules (`modules/system/`)
| File | Purpose |
|------|---------|
| `base.nix` | pipewire, docker, syncthing, tailscale, flatpak, bluetooth, zram |
| `security.nix` | kernel hardening, AppArmor, firewall, SSH defaults via `lib.mkDefault` |
| `nvidia.nix` | Intel + NVIDIA PRIME offload — bus IDs patched by install wizard |
| `networking.nix` | NetworkManager + iwd, systemd-resolved (Cloudflare/Quad9 DoT) |
| `services.nix` | cron, locate (plocate), avahi |
| `theme.nix` | Stylix, NES palette (`themes/nes.yaml`), wallpaper: `wallpapers/emerald-07.png` |
| `vpn.nix` | Just installs `openvpn` package — service config is post-install |
| `printing.nix` | CUPS enabled, no drivers (add printer-specific ones as needed) |

### Home modules (`home/`)
| File | Purpose |
|------|---------|
| `packages.nix` | User packages — **not all verified to exist in nixpkgs-unstable** |
| `shell.nix` | bash, starship, alacritty, git, fzf, zoxide, lazygit |
| `hyprland.nix` | Hyprland + hypridle + hyprlock |
| `waybar.nix` | Status bar |
| `walker.nix` | Walker launcher config files (package installed via packages.nix) |
| `neovim.nix` | LazyVim bootstrap |
| `scripts.nix` | nixeko CLI scripts + Nautilus bookmarks |
| `firefox.nix` | Firefox profile + extensions via home-manager |
| `gtk.nix` | Papirus icons, Bibata cursor |
| `mime.nix` | Default MIME type associations |

### Themes (`themes/`)
- `nes.yaml` — bundled NES base16 scheme (16 colors, dark retro aesthetic)

### Docker services (`docker/`)
- **Pi-hole** — DNS ad blocker. Set up post-install: `cd docker/pihole && cp .env.example .env && docker compose up -d`
- **SearXNG** — self-hosted search at localhost:8888

### VPN (`vpn/`)
- `vpn/configs/` — drop `.ovpn` files here post-install (gitignored)
- `vpn/credentials` — `user\npassword` format (gitignored)
- See `vpn/README.md`

---

## Known risks / likely next failures

These have NOT been verified against current nixpkgs-unstable. If nixos-install fails at build time (after eval passes), check these first:

**packages.nix — unverified package names:**
- `wayfreeze` — Wayland screen freeze utility, may not be in nixpkgs
- `wiremix` — PipeWire mixer TUI, may not be in nixpkgs
- `gpu-screen-recorder` — GPU-accelerated recorder, may need overlay
- `swayosd` — OSD for volume/brightness, verify name
- `walker` — app launcher, verify it's in nixpkgs-unstable
- `wl-clip-persist` — clipboard persistence, verify name
- `sublime4` — unfree, should work with `allowUnfree = true`
- `typora` — unfree markdown editor, should work

**Home manager modules:**
- `firefox.nix` — uses home-manager Firefox module; verify extension IDs are current
- `hyprland.nix` — Hyprland options change frequently on unstable

**If a package fails:** comment it out in `packages.nix`, rebuild, install manually post-boot.

---

## Install flow

```bash
# In NixOS ISO VM (graphical ISO: open terminal from taskbar, Calamares runs in background)
nix-shell -p git
git clone https://github.com/IronDingo/nixeko
sudo bash nixeko/bin/nixeko-install
```

Wizard steps (I–XVII):
1. Name ship (hostname)
2. Select profile (nixeko / nixeko-dinghy / nixeko-beacon)
3. Hull scan (hardware detection, VM skipped)
4. NVIDIA detection prompt
5. Select disk
6. Install mode (full / dual boot)
7. Encryption (LUKS y/n)
8. Confirm plan
9. Partition disk
10. Seal hull (LUKS format + open)
11. Format + mount filesystems
12. Copy repo + patch username
13. nixos-generate-config + patch hostname/flake
14. Detect NVIDIA bus IDs (real hardware only)
15. Patch LUKS into hardware-configuration.nix (if encrypted)
16. nixos-install (the long one)
17. Set captain + root passwords
18. Farewell summary

---

## First boot checklist

```bash
nixeko doctor
cd ~/Projects/nixeko/docker/pihole && cp .env.example .env   # set PIHOLE_PASSWORD
docker compose up -d
cd ../searxng && docker compose up -d
# Edit home/shell.nix: set git userName + userEmail
nixeko rebuild
```

---

## CLI (`bin/nixeko`)

```
nixeko update           flake update + rebuild
nixeko rebuild          rebuild + switch
nixeko rollback         revert to previous generation
nixeko theme <name>     switch base16 theme + rebuild
nixeko wallpaper <f>    switch wallpaper + rebuild
nixeko doctor           full system health check
nixeko rescue           recovery reference
```

---

## Important implementation notes

- `security.nix` uses `lib.mkDefault false` for SSH — allows beacon profile to override with `enable = true`
- `base.nix` XDG portal has only GTK portal; Hyprland portal added per-host in `hosts/nixeko/` and `hosts/nixeko-vm/`
- `flake.nix` `homeFor` function hardcodes `home-manager.users.eko` — `patch_username` in installer sed-replaces `eko` with `$CAPTAIN` across all files
- Installer uses `git add -A` before `nixos-install` so staged-but-uncommitted files (hardware-configuration.nix etc.) are visible to the git flake fetcher
- `detect_nvidia()` returns `return 0` (not bare `return`) — critical: bare `return` in a `false || return` inherits exit code 1 and fires ERR trap

---

## Repo
`github.com/IronDingo/nixeko` — branch `master`
