NAME="peek"
DESC="System inspector — ports, sysinfo, dashboard (local script)"

check() {
  command -v peek &>/dev/null
}

install() {
  local script="${HOME}/.setup/bin/peek"
  if [[ ! -f "$script" ]]; then
    echo "peek script not found at ${script} — is the repo cloned?"
    return 1
  fi
  chmod +x "$script"
  export PATH="${HOME}/.setup/bin:${PATH}"
}
