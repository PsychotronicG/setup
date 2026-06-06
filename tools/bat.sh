NAME="bat"
DESC="A cat clone with syntax highlighting"
CATEGORY="shell"
BINARY="batcat"

check() { command -v bat &>/dev/null || command -v batcat &>/dev/null; }

install() {
  case "$RIG_PKG_MANAGER" in
    apt)
      pkg_install bat
      # Ubuntu/Debian installs as 'batcat' — create a bat alias
      if ! command -v bat &>/dev/null && command -v batcat &>/dev/null; then
        mkdir -p ~/.local/bin
        ln -sf "$(command -v batcat)" ~/.local/bin/bat
      fi
      ;;
    *) pkg_install bat ;;
  esac
}
