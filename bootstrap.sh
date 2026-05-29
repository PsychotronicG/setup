#!/usr/bin/env bash
# Run once on a new machine to wire up rig on PATH.
# Usage: bash ~/.setup/bootstrap.sh

set -e

SETUP_DIR="${HOME}/.setup"
BIN_DIR="${SETUP_DIR}/bin"

detect_shell_rc() {
  if [[ "$SHELL" == */zsh ]]; then
    echo "${HOME}/.zshrc"
  elif [[ "$SHELL" == */bash ]]; then
    echo "${HOME}/.bashrc"
  else
    echo ""
  fi
}

SHELL_RC=$(detect_shell_rc)

if [[ -z "$SHELL_RC" ]]; then
  echo "Could not detect shell config file. Add this to your shell RC manually:"
  echo "  export PATH=\"\$HOME/.setup/bin:\$PATH\""
  exit 1
fi

if grep -q '\.setup/bin' "$SHELL_RC" 2>/dev/null; then
  echo "✓  PATH already configured in ${SHELL_RC}"
else
  {
    echo ""
    echo "# rig - terminal setup manager"
    echo "export PATH=\"\$HOME/.setup/bin:\$PATH\""
  } >> "$SHELL_RC"
  echo "✓  Added ~/.setup/bin to PATH in ${SHELL_RC}"
fi

chmod +x "${BIN_DIR}"/rig "${BIN_DIR}"/cl "${BIN_DIR}"/dev 2>/dev/null || true

# zsh completions
if [[ "$SHELL" == */zsh ]]; then
  if ! grep -q 'setup/zsh/completions' "$SHELL_RC" 2>/dev/null; then
    {
      echo ""
      echo "# rig - zsh completions"
      echo "fpath=(\"\$HOME/.setup/zsh/completions\" \$fpath)"
      echo "autoload -Uz compinit && compinit"
    } >> "$SHELL_RC"
    echo "✓  Added zsh completions to ${SHELL_RC}"
  else
    echo "✓  Zsh completions already configured"
  fi
fi

if [[ ! -f "${SETUP_DIR}/.active_profile" ]]; then
  echo "base" > "${SETUP_DIR}/.active_profile"
  echo "✓  Active profile set to 'base'"
fi

echo ""
echo "All done. Run one of:"
echo "  source ${SHELL_RC}"
echo "  exec \$SHELL"
echo ""
echo "Then: rig doctor"
