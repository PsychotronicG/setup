NAME="seek"
DESC="Fuzzy file & code search (bat, rg, ast-grep)"

check() {
  command -v seek &>/dev/null
}

install() {
  local script="${HOME}/.setup/bin/seek"
  if [[ ! -f "$script" ]]; then
    echo "seek script not found at ${script} — is the repo cloned?"
    return 1
  fi
  chmod +x "$script"
  mkdir -p "${HOME}/.setup/seek"
  export PATH="${HOME}/.setup/bin:${PATH}"

  # per-machine ignore list — edit to skip large dirs on this machine
  local seek_ignore="${HOME}/.setup/seek/ignore"
  if [[ ! -f "$seek_ignore" ]]; then
    cat > "$seek_ignore" << 'EOF'
# seek ignore list — directories to skip when searching
# One entry per line. Lines starting with # are ignored.

Downloads
snap
.cache
.nvm
.npm
.steam
.local
EOF
    echo "✓  Created ~/.setup/seek/ignore (edit to add machine-specific dirs)"
  fi

  # zsh keybinding — ctrl+f to open seek
  local shell_rc="${HOME}/.zshrc"
  [[ "$SHELL" != */zsh ]] && shell_rc="${HOME}/.bashrc"
  if ! grep -q '_seek_widget' "$shell_rc" 2>/dev/null; then
    cat >> "$shell_rc" << 'EOF'

# seek — ctrl+f to open file search
_seek_widget() { seek; zle reset-prompt; }
zle -N _seek_widget
bindkey '^F' _seek_widget
EOF
    echo "✓  Added ctrl+f keybinding to ${shell_rc}"
  fi

  echo "seek installed. Optional enhancements: bat, fd, rg (ripgrep), sg (ast-grep)"
}
