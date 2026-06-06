NAME="vagrant"
DESC="VM lifecycle manager (pairs with libvirt/KVM)"
CATEGORY="dev"

check() {
  command -v vagrant &>/dev/null && vagrant plugin list 2>/dev/null | grep -q 'vagrant-libvirt'
}

install() {
  case "$RIG_PKG_MANAGER" in
    apt)
      # HashiCorp repo gives a more up-to-date vagrant than the Ubuntu default
      if ! command -v vagrant &>/dev/null; then
        wget -qO- https://apt.releases.hashicorp.com/gpg \
          | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
          | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt-get update -qq
        pkg_install vagrant
      fi
      # libvirt plugin needs the dev headers to build
      pkg_install libvirt-dev ruby-dev
      vagrant plugin install vagrant-libvirt
      ;;
    pacman)
      pkg_install vagrant
      pkg_install libvirt
      vagrant plugin install vagrant-libvirt
      ;;
    brew)
      brew install vagrant
      echo "Note: vagrant-libvirt is not supported on macOS. Use the VMware or VirtualBox provider instead."
      ;;
    *)
      echo "Unsupported package manager: $RIG_PKG_MANAGER"
      return 1
      ;;
  esac
}
