NAME="cl"
DESC="Command library (local script)"

check() {
  command -v cl &>/dev/null
}

install() {
  local script="${HOME}/.setup/bin/cl"
  if [[ ! -f "$script" ]]; then
    echo "cl script not found at ${script} — is the repo cloned?"
    return 1
  fi
  chmod +x "$script"
  if ! python3 -c "import yaml" 2>/dev/null; then
    pip3 install pyyaml --quiet || sudo apt-get install -y python3-yaml
  fi
  export PATH="${HOME}/.setup/bin:${PATH}"
}
