NAME="rust"
DESC="Rust toolchain + cargo (needed for tools built from source on Arch)"
CATEGORY="dev"
BINARY="cargo"

check() { command -v cargo &>/dev/null; }

install() {
  case "$RIG_PKG_MANAGER" in
    pacman) pkg_install rust ;;
    apt)    pkg_install cargo ;;
    dnf)    pkg_install cargo ;;
    zypper) pkg_install cargo ;;
    brew)
      # Rust comes via rustup on macOS
      if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
      fi
      ;;
    *)
      echo "Install Rust via https://rustup.rs"
      return 1
      ;;
  esac
}
