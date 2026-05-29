NAME="ripgrep"
DESC="Fast recursive search tool (rg)"

check() {
  command -v rg &>/dev/null
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y ripgrep
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm ripgrep
  elif command -v brew &>/dev/null; then
    brew install ripgrep
  else
    echo "No supported package manager found. Install ripgrep manually: https://github.com/BurntSushi/ripgrep"
    return 1
  fi
}
