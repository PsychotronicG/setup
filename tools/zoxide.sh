NAME="zoxide"
DESC="Smarter cd — jumps to frequently used directories"

check() {
  command -v zoxide &>/dev/null
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y zoxide 2>/dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm zoxide
  elif command -v brew &>/dev/null; then
    brew install zoxide
  else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  fi
}
