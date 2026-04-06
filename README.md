```
 __   __ ____  ____  ____  ____  __
 \ \ / // ___||  __||  __||  __||  |
  \ V / \___ \|___ \|___ \|___ \|  |
   \_/  |____/|____/|____/|____/|__|

  commission your NixOS system
```

**vessel** is a guided NixOS installer and daily-driver management CLI.
Boot the ISO, answer a few questions, walk away with a working system.
No manual partitioning. No config editing before install. No surprises.

---

## what it gives you

- **Interactive install wizard** — disk, encryption, username, NVIDIA detection, nixos-hardware
- **Four profiles** to choose from at install time
- **Stylix theming** — eight base16 themes, switch with one command
- **Home Manager** — packages, shell, Hyprland, Waybar, Neovim, all declarative
- **`vessel` CLI** — rebuild, update, rollback, theme switching, health checks
- **Proper parameterization** — username, hostname, GPU config live in one Nix file, not scattered sed targets

---

## profiles

```
nixeko          Full Hyprland desktop. The main event.
nixeko-dinghy   BSPWM. Lean, X11, fast.
nixeko-beacon   Headless. SSH only. No display server.
nixeko-vm       QEMU test target. Same config, virtual hardware.
```

---

## install

You need a NixOS ISO. The minimal one works fine.

```bash
# 1. Boot the NixOS ISO on your target machine

# 2. Get internet (wifi: nmtui  or  iwctl)

# 3. Clone and run the wizard
nix-shell -p git
git clone https://github.com/IronDingo/nixeko
cd nixeko
sudo bash bin/nixeko-install
```

The wizard walks you through:

```
  ┌──────────────────────────────────────────────┐
  │  I.    Name your ship        (hostname)       │
  │  II.   Name the captain      (username)       │
  │  III.  Choose your profile                    │
  │  IV.   Detect hardware module                 │
  │  V.    NVIDIA?                                │
  │  VI.   Select target disk                     │
  │  VII.  Install mode  (full / dual-boot)       │
  │  VIII. Encryption?   (LUKS)                   │
  │  IX.   Confirm → install                      │
  └──────────────────────────────────────────────┘
```

Installation downloads the full system closure. A good connection takes
15–30 minutes. If the download drops, press **Enter** to retry — cached
packages stay on disk. Type `q` to abort.

---

## after the first boot

```bash
nixeko doctor          # health check — see what needs attention
nixeko theme nes       # switch theme (nes is the default)
nixeko rebuild         # rebuild after editing config
nixeko update          # update flake inputs + rebuild
nixeko rollback        # revert to previous generation
nixeko clean           # garbage collect old generations
```

---

## themes

```bash
nixeko theme nes                # NES palette             ← default
nixeko theme catppuccin-mocha   # purple pastels
nixeko theme gruvbox-dark-hard  # warm amber
nixeko theme nord               # arctic blue
nixeko theme tokyo-night-dark   # tokyo night
nixeko theme rose-pine          # warm rose
nixeko theme kanagawa           # japanese ink
nixeko theme gameboy            # classic green
```

---

## customising

Everything lives at `~/Projects/nixeko` after install.

```
nixeko/
├── hosts/
│   └── <profile>/
│       └── params.nix        ← username, hostname, GPU settings
├── home/
│   ├── packages.nix          ← add / remove packages
│   ├── hyprland.nix          ← keybinds, monitor config
│   └── ...
├── modules/system/           ← system-level config
├── themes/                   ← base16 yaml files
└── wallpapers/               ← drop .png files here
```

Add a package:
```bash
nixeko install ripgrep
```

Remove a package:
```bash
nixeko remove ripgrep
```

Or edit `home/packages.nix` directly, then `nixeko rebuild`.

---

## keybinds (quick reference)

```
Super + Enter               Terminal
Super + Alt + Space         Launcher (walker)
Super + Shift + B           Firefox
Super + Shift + N           Neovim
Super + Shift + O           Obsidian
Super + Q                   Close window
Super + F                   Fullscreen
Super + V                   Float toggle

Super + Shift + Ctrl + V    VPN menu
Super + Shift + Ctrl + P    Pi-hole menu
Super + Shift + Ctrl + Q    Power menu
```

---

## recovery

If something breaks:

```bash
# From TTY (Ctrl+Alt+F2):
nixeko rollback

# Won't boot? At the systemd-boot menu, select a previous generation.

# Nuclear option (boot ISO, mount, chroot):
cryptsetup open /dev/sdXY nixeko-vault
mount /dev/mapper/nixeko-vault /mnt
mount /dev/sdX1 /mnt/boot
nixos-enter --root /mnt
nixos-rebuild switch --rollback
```

---

## just want the config?

If you already have NixOS installed and just want to apply this configuration,
see **[dotfiles](https://github.com/IronDingo/dotfiles)** — same config,
no installer, three commands to apply.

---

> *The ship does not ask why you sail. It asks only that you do.*
