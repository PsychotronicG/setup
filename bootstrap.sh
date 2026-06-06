#!/usr/bin/env bash
# rig bootstrap — run on a fresh machine to install rig from scratch.
#
# If the repo is public:
#   curl -sSf https://raw.githubusercontent.com/PsychotronicG/setup/main/bootstrap.sh | bash
#
# If the repo is private (SSH key must be on the machine first):
#   bash <(curl -sSf https://raw.githubusercontent.com/PsychotronicG/setup/main/bootstrap.sh)
#   — or copy/paste this file manually.

set -euo pipefail

REPO_SSH="git@github.com:PsychotronicG/setup.git"
REPO_HTTPS="https://github.com/PsychotronicG/setup.git"
SETUP_DIR="${HOME}/.setup"
BIN_DIR="${SETUP_DIR}/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

step()  { echo -e "${BOLD}==> ${1}${NC}"; }
ok()    { echo -e "  ${GREEN}✓${NC}  ${1}"; }
warn()  { echo -e "  ${YELLOW}!${NC}  ${1}"; }
fatal() { echo -e "  ${RED}✗${NC}  ${1}" >&2; exit 1; }

# ── OS / package manager detection ───────────────────────────────────────────

detect_pkg_manager() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    PKG_MANAGER="brew"; PKG_INSTALL="brew install"; return
  fi
  if [[ -f /etc/os-release ]]; then
    local id id_like
    id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    id_like=$(grep '^ID_LIKE=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' || true)
    for token in $id $id_like; do
      case "$token" in
        ubuntu|debian|linuxmint|pop|kali|raspbian)
          PKG_MANAGER="apt"; PKG_INSTALL="sudo apt-get install -y"; return ;;
        arch|manjaro|endeavouros|garuda|cachyos|artix)
          PKG_MANAGER="pacman"; PKG_INSTALL="sudo pacman -S --noconfirm"; return ;;
        fedora)
          PKG_MANAGER="dnf"; PKG_INSTALL="sudo dnf install -y"; return ;;
        opensuse*|sles)
          PKG_MANAGER="zypper"; PKG_INSTALL="sudo zypper install -y"; return ;;
      esac
    done
  fi
  PKG_MANAGER="unknown"; PKG_INSTALL=""
}

PKG_MANAGER=""
PKG_INSTALL=""
detect_pkg_manager

# ── Arch: offer to install Rust/cargo ────────────────────────────────────────

if [[ "$PKG_MANAGER" == "pacman" ]] && ! command -v cargo &>/dev/null; then
  echo ""
  echo -e "${BOLD}Arch detected.${NC} Some tools (e.g. ast-grep) require Rust/cargo to build from source."
  echo -ne "  Install rust via pacman now? [Y/n] "
  read -r _rust_reply </dev/tty
  if [[ "${_rust_reply:-y}" =~ ^[Yy]$ ]]; then
    sudo pacman -S --noconfirm rust && ok "rust/cargo installed"
  else
    warn "Skipped — run 'rig install rust' later if needed"
  fi
  echo ""
fi

# ── Install git if missing ────────────────────────────────────────────────────

step "Checking git"
if ! command -v git &>/dev/null; then
  warn "git not found — installing"
  if [[ "$PKG_MANAGER" == "brew" ]]; then
    # macOS: trigger Xcode CLI tools or use brew if already available
    if command -v brew &>/dev/null; then
      brew install git
    else
      echo "Install Xcode Command Line Tools, then re-run this script."
      xcode-select --install 2>/dev/null || true
      exit 1
    fi
  elif [[ -n "$PKG_INSTALL" ]]; then
    $PKG_INSTALL git
  else
    fatal "Cannot install git — no package manager detected. Install git manually and re-run."
  fi
fi
ok "git $(git --version | cut -d' ' -f3)"

# ── SSH key check ─────────────────────────────────────────────────────────────

step "Checking SSH key"
HAS_SSH_KEY=false
for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa ~/.ssh/id_ecdsa; do
  [[ -f "$key" ]] && { HAS_SSH_KEY=true; ok "Found key: ${key}"; break; }
done

if ! $HAS_SSH_KEY; then
  warn "No SSH key found."
  warn "Private tools (modport, dream, etc.) need SSH access to GitHub."
  warn "To generate one:  ssh-keygen -t ed25519 -C \"$(whoami)@$(hostname)\""
  warn "Then add it to:   https://github.com/settings/keys"
  echo ""
fi

# ── Clone or update rig ───────────────────────────────────────────────────────

step "Setting up rig at ${SETUP_DIR}"

if [[ -d "${SETUP_DIR}/.git" ]]; then
  ok "Repo already cloned — pulling latest"
  git -C "$SETUP_DIR" pull --ff-only
else
  if [[ -d "$SETUP_DIR" ]]; then
    fatal "${SETUP_DIR} exists but is not a git repo. Move it out of the way and re-run."
  fi

  # Try SSH first, fall back to HTTPS
  if $HAS_SSH_KEY && ssh -T git@github.com 2>&1 | grep -q 'successfully authenticated'; then
    ok "Cloning via SSH"
    git clone "$REPO_SSH" "$SETUP_DIR"
  else
    warn "SSH auth not confirmed — trying HTTPS (works only if repo is public)"
    git clone "$REPO_HTTPS" "$SETUP_DIR" || \
      fatal "Clone failed. Ensure the repo is public, or add your SSH key to GitHub and re-run."
  fi
fi

# ── Wire up PATH ──────────────────────────────────────────────────────────────

step "Configuring shell"

detect_shell_rc() {
  if [[ "${SHELL:-}" == */zsh ]]; then echo "${HOME}/.zshrc"
  elif [[ "${SHELL:-}" == */bash ]]; then echo "${HOME}/.bashrc"
  else echo ""; fi
}

SHELL_RC=$(detect_shell_rc)

if [[ -z "$SHELL_RC" ]]; then
  warn "Could not detect shell RC. Add this manually:"
  echo "  export PATH=\"\$HOME/.setup/bin:\$PATH\""
else
  if grep -q '\.setup/bin' "$SHELL_RC" 2>/dev/null; then
    ok "PATH already configured in ${SHELL_RC}"
  else
    { echo ""; echo "# rig — terminal setup manager"; echo "export PATH=\"\$HOME/.setup/bin:\$PATH\""; } >> "$SHELL_RC"
    ok "Added ~/.setup/bin to PATH in ${SHELL_RC}"
  fi

  if [[ "${SHELL:-}" == */zsh ]]; then
    if ! grep -q 'setup/zsh/completions' "$SHELL_RC" 2>/dev/null; then
      { echo ""; echo "# rig — zsh completions"; echo "fpath=(\"\$HOME/.setup/zsh/completions\" \$fpath)"; echo "autoload -Uz compinit && compinit"; } >> "$SHELL_RC"
      ok "Added zsh completions to ${SHELL_RC}"
    else
      ok "Zsh completions already configured"
    fi
  fi
fi

chmod +x "${BIN_DIR}"/rig "${BIN_DIR}"/cl "${BIN_DIR}"/dev "${BIN_DIR}"/seek "${BIN_DIR}"/peek 2>/dev/null || true

# ── Active profile ────────────────────────────────────────────────────────────

if [[ ! -f "${SETUP_DIR}/.active_profile" ]]; then
  echo "base" > "${SETUP_DIR}/.active_profile"
  ok "Active profile set to 'base'"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}${BOLD}All done.${NC} Next steps:"
echo ""
echo -e "  1. Reload your shell:  ${BOLD}source ${SHELL_RC:-~/.zshrc}${NC}"
echo -e "  2. Check status:       ${BOLD}rig doctor${NC}"
echo -e "  3. Switch profile:     ${BOLD}rig profile use <name>${NC}  (optional)"
echo -e "  4. Install tools:      ${BOLD}rig install${NC}"
echo ""
