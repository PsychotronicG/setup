NAME="dev"
DESC="Repo manager (local script)"
CATEGORY="dev"

check() {
  command -v dev &>/dev/null
}

install() {
  local script="${HOME}/.setup/bin/dev"
  if [[ ! -f "$script" ]]; then
    echo "dev script not found at ${script} — is the repo cloned?"
    return 1
  fi
  chmod +x "$script"
  local shell_rc
  if [[ "$SHELL" == */zsh ]]; then
    shell_rc="${HOME}/.zshrc"
  else
    shell_rc="${HOME}/.bashrc"
  fi
  if ! grep -q '\.setup/bin' "$shell_rc" 2>/dev/null; then
    echo '' >> "$shell_rc"
    echo '# rig - terminal setup manager' >> "$shell_rc"
    echo 'export PATH="$HOME/.setup/bin:$PATH"' >> "$shell_rc"
  fi
  export PATH="${HOME}/.setup/bin:${PATH}"
  echo "Run: source ${shell_rc}"
}
