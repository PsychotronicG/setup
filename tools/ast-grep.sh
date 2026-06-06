NAME="ast-grep"
DESC="Structural code search and rewrite tool (ast-grep)"
CATEGORY="search"

check() {
  command -v ast-grep &>/dev/null
}

_remove_sg_conflict() {
  # ast-grep installs an 'sg' symlink that shadows /usr/bin/sg (Linux group tool).
  # We only need the 'ast-grep' binary, so remove the conflicting symlink.
  local brew_sg
  brew_sg="$(brew --prefix 2>/dev/null)/bin/sg"
  if [[ -L "$brew_sg" ]]; then
    rm -f "$brew_sg"
    echo "✓  Removed brew sg symlink (kept /usr/bin/sg intact)"
  fi
}

install() {
  if command -v brew &>/dev/null; then
    brew install ast-grep
    _remove_sg_conflict
  elif command -v npm &>/dev/null; then
    npm install -g @ast-grep/cli
  elif command -v cargo &>/dev/null; then
    cargo install ast-grep --locked
  else
    echo "No supported installer found. Options:"
    echo "  brew install ast-grep"
    echo "  npm install -g @ast-grep/cli"
    echo "  cargo install ast-grep --locked"
    return 1
  fi
}
