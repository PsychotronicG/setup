NAME="steam"
DESC="Steam game launcher"
CATEGORY="apps"

check() { command -v steam &>/dev/null || [[ -d "/Applications/Steam.app" ]]; }

install() {
  case "$RIG_PKG_MANAGER" in
    apt)    pkg_install steam ;;
    pacman) pkg_install steam ;;
    brew)   brew install --cask steam ;;
    *)
      echo "Install Steam manually: https://store.steampowered.com/about/"
      return 1
      ;;
  esac
}
