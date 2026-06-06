NAME="steam"
DESC="Steam game launcher"
CATEGORY="apps"

check() {
  command -v steam &>/dev/null || [[ -d "/Applications/Steam.app" ]]
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y steam
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm steam
  elif command -v brew &>/dev/null; then
    brew install --cask steam
  else
    echo "No supported package manager found. Install Steam manually: https://store.steampowered.com/about/"
    return 1
  fi
}
