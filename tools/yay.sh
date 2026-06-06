NAME="yay"
DESC="AUR helper for Arch Linux (builds from source)"
CATEGORY="dev"

check() { command -v yay &>/dev/null; }

install() {
  if [[ "$RIG_PKG_MANAGER" != "pacman" ]]; then
    echo "yay is Arch-only — skipping on ${RIG_PKG_MANAGER}"
    return 0
  fi

  pkg_install base-devel git

  local tmp
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
}
