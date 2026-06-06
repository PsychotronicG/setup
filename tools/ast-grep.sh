NAME="ast-grep"
DESC="Structural code search and rewrite tool (ast-grep)"
CATEGORY="search"

check() { command -v ast-grep &>/dev/null || [[ -x "${HOME}/.cargo/bin/ast-grep" ]]; }

_remove_sg_conflict() {
  local brew_sg
  brew_sg="$(brew --prefix 2>/dev/null)/bin/sg"
  if [[ -L "$brew_sg" ]]; then
    rm -f "$brew_sg"
    echo "✓  Removed brew sg symlink (kept /usr/bin/sg intact)"
  fi
}

install() {
  case "$RIG_PKG_MANAGER" in
    brew)
      brew install ast-grep
      _remove_sg_conflict
      ;;
    pacman)
      # ast-grep is in the AUR — try yay/paru, fall back to cargo
      if command -v yay &>/dev/null; then
        yay -S --noconfirm ast-grep-bin
      elif command -v paru &>/dev/null; then
        paru -S --noconfirm ast-grep-bin
      elif command -v cargo &>/dev/null; then
        cargo install ast-grep --locked
        export PATH="${HOME}/.cargo/bin:${PATH}"
      else
        echo "→  Installing rust/cargo via pacman..."
        pkg_install rust
        export PATH="${HOME}/.cargo/bin:${PATH}"
        cargo install ast-grep --locked
      fi
      ;;
    *)
      if command -v npm &>/dev/null; then
        npm install -g @ast-grep/cli
      elif command -v cargo &>/dev/null; then
        cargo install ast-grep --locked
      else
        echo "No supported installer. Try: npm install -g @ast-grep/cli"
        return 1
      fi
      ;;
  esac
}
