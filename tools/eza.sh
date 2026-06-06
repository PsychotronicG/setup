NAME="eza"
DESC="Modern replacement for ls"
CATEGORY="shell"

check() {
  command -v eza &>/dev/null
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y eza 2>/dev/null || {
      # Fallback: install via cargo if apt doesn't have it
      if command -v cargo &>/dev/null; then
        cargo install eza
      else
        echo "eza not available via apt and cargo not installed. Install manually: https://github.com/eza-community/eza"
        return 1
      fi
    }
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm eza
  elif command -v brew &>/dev/null; then
    brew install eza
  else
    echo "No supported package manager found. Install eza manually: https://github.com/eza-community/eza"
    return 1
  fi
}
