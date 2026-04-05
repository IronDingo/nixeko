# Testing nixeko in a VM

The safest way to validate config changes before deploying to real hardware.

---

## What you need

- A NixOS machine (or existing NixOS install) to build from
- `virt-manager` or `qemu` available
- ~20 GB free disk space for the VM image

---

## Step 1 — Check the flake evaluates

This catches syntax errors and missing references without building anything:

```bash
cd ~/Projects/nixeko
nix flake check
```

If it passes silently, the nix expressions are valid.

---

## Step 2 — Build the VM target

`nixeko-vm` is a lightweight test host (no NVIDIA, no hardware-specific config):

```bash
nix build .#nixosConfigurations.nixeko-vm.config.system.build.toplevel
```

A successful build means the full system closure compiles. This is the most important test.

If it fails, read the error — it will point to the exact module and line. Common causes:

- Package name wrong (not in nixpkgs) → check `nix search nixpkgs <name>`
- Option doesn't exist → check NixOS options at search.nixos.org
- Type mismatch (string where list expected, etc.)

---

## Step 3 — Run it as a VM

```bash
nix build .#nixosConfigurations.nixeko-vm.config.system.build.vm
./result/bin/run-nixeko-vm-vm
```

This boots nixeko-vm in QEMU. Login: `root` / password: `nixeko`

Check inside the VM:
- `systemctl --failed` — any failed units?
- `hyprland` — does it launch? (may need a display, works best with virt-manager)
- `nixeko doctor` — what does it report?

---

## Step 4 — Test a specific change

After editing any `.nix` file:

```bash
# Quick syntax check
nix-instantiate --eval flake.nix

# Rebuild just the affected module (faster than full build)
nix build .#nixosConfigurations.nixeko-vm.config.system.build.toplevel 2>&1 | tail -20
```

---

## Step 5 — Test the installer wizard

Boot a NixOS ISO in virt-manager. If using the **graphical ISO**, ignore the Calamares installer — open the terminal emulator from the taskbar instead. Then:

```bash
nix-shell -p git
git clone https://github.com/IronDingo/nixeko
sudo bash nixeko/bin/nixeko-install
```

Select "full disk" mode on the VM disk. This validates the entire install flow without touching real hardware.

---

## Common failure patterns

| Error | Likely cause |
|---|---|
| `attribute 'X' missing` | Package name wrong — search nixpkgs |
| `infinite recursion` | Circular module import |
| `conflict between...` | Two modules setting the same option |
| `expected string, got list` | Wrong type for an option |
| Build hangs at `evaluating` | Large package downloading — wait it out |

---

## When to test what

| Change | Minimum test |
|---|---|
| Package added/removed | `nix build .#...vm.config.system.build.toplevel` |
| New system module | `nix flake check` + VM build |
| Theme / wallpaper | `nixeko rebuild` directly (low risk) |
| Hyprland keybinds | `nixeko rebuild` directly |
| VPN config changes | VM build + check `systemctl list-units openvpn*` |
| Installer changes | Full wizard run in virt-manager VM |

---

## Promoting to real hardware

Once the VM build passes:

```bash
# On the actual machine
cd ~/Projects/nixeko
sudo nixos-rebuild switch --flake .#nixeko
```

If something breaks: `nixeko rollback` or select a previous generation from the boot menu (Space at startup).
