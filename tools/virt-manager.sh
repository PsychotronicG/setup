NAME="virt-manager"
DESC="QEMU/KVM virtual machine manager"
CATEGORY="dev"

check() {
  command -v virt-manager &>/dev/null
}

install() {
  case "$RIG_PKG_MANAGER" in
    apt)
      pkg_install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils virtinst
      sudo usermod -aG libvirt,kvm "$USER"
      echo "✓  Added $USER to libvirt and kvm groups — log out and back in to apply"
      ;;
    pacman)
      pkg_install qemu-full virt-manager virt-viewer dnsmasq bridge-utils
      sudo systemctl enable --now libvirtd
      sudo usermod -aG libvirt,kvm "$USER"
      echo "✓  Enabled libvirtd and added $USER to libvirt and kvm groups — log out and back in"
      ;;
    brew)
      echo "Native KVM is not available on macOS. Consider UTM (https://mac.getutm.app) instead."
      return 1
      ;;
    *)
      echo "Unsupported package manager: $RIG_PKG_MANAGER"
      return 1
      ;;
  esac
}
