NAME="bat"
DESC="A cat clone with syntax highlighting"
CATEGORY="shell"

check() {
  command -v bat &>/dev/null || command -v batcat &>/dev/null
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y bat
    # On Ubuntu/Debian bat is installed as batcat
    if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
      mkdir -p ~/.local/bin
      ln -sf "$(command -v batcat)" ~/.local/bin/bat
    fi
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm bat
  elif command -v brew &>/dev/null; then
    brew install bat
  else
    echo "No supported package manager found. Install bat manually: https://github.com/sharkdp/bat"
    return 1
  fi
}
