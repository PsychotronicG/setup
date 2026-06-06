NAME="eza"
DESC="Modern replacement for ls"
CATEGORY="shell"

install() {
  case "$RIG_PKG_MANAGER" in
    apt)
      pkg_install eza 2>/dev/null || {
        command -v cargo &>/dev/null && cargo install eza || {
          echo "eza unavailable via apt. Install cargo first, or upgrade apt sources."
          return 1
        }
      }
      ;;
    *) pkg_install eza ;;
  esac
}
