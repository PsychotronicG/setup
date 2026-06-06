NAME="fzf"
DESC="Fuzzy finder for the terminal"
CATEGORY="shell"

check() {
  command -v fzf &>/dev/null
}

install() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get install -y fzf
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm fzf
  elif command -v brew &>/dev/null; then
    brew install fzf
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  fi
}
