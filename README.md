# rig

Portable terminal setup manager. Define profiles of tools, install them with one command, and bootstrap any new machine from a single `curl`.

```
curl -sSf https://raw.githubusercontent.com/PsychotronicG/setup/main/bootstrap.sh | bash
```

## How it works

Tools live in `tools/*.sh`. Each tool declares its name, category, a `check()` function (is it installed?), and an `install()` function. The package manager is auto-detected — apt, pacman, dnf, zypper, or brew.

Profiles are plain text lists of tool names in `profiles/`. You pick an active profile and `rig` only shows and installs what's in it.

## Commands

```
rig doctor                  check installed vs active profile
rig install                 install all missing tools
rig install <tool>          install a specific tool
rig profile list            list profiles
rig profile use <name>      switch active profile
rig profile new             create a profile interactively (fzf picker)
rig profile edit [name]     edit a profile
```

## Tools

| Tool | Category | Description |
|------|----------|-------------|
| fzf | shell | Fuzzy finder |
| ripgrep | search | Fast recursive search (`rg`) |
| bat | shell | `cat` with syntax highlighting |
| eza | shell | Modern `ls` replacement |
| zoxide | shell | Smarter `cd` with frecency |
| ast-grep | search | Structural code search |
| seek | search | Fuzzy file & code search (wraps rg, bat, ast-grep) |
| dev | dev | Repo manager |
| cl | dev | Command library |
| peek | dev | System inspector — ports, sysinfo, dashboard |
| modport | dev | Mod manager ([private](https://github.com/PsychotronicG/modport)) |
| dream | dev | Dream journal CLI ([private](https://github.com/PsychotronicG/dream)) |
| steam | gaming | Steam game client |
| virt-manager | dev | QEMU/KVM virtual machine manager |
| vagrant | dev | VM lifecycle manager (libvirt backend) |

## Adding a tool

Create `tools/<name>.sh`:

```bash
NAME="mytool"
DESC="What it does"
CATEGORY="shell"      # shell | search | dev | gaming | other
BINARY="mytool"       # optional: binary name if different from NAME

check() { command -v mytool &>/dev/null; }

install() {
  pkg_install mytool  # uses the detected package manager
}
```

Then add `mytool` to a profile in `profiles/`.

## Profiles

`base.txt` — everything. `standard.txt` — a leaner daily-driver set.

Create your own with `rig profile new` — an interactive fzf picker lets you browse by category and toggle tools with Tab.

## OS support

Tested on Ubuntu and Arch Linux. Should work on any distro with apt, pacman, dnf, or zypper, and on macOS with Homebrew.
