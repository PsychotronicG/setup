NAME="zoxide"
DESC="Smarter cd — jumps to frequently used directories"
CATEGORY="shell"

check() { command -v zoxide &>/dev/null; }

install() {
  pkg_install zoxide 2>/dev/null || \
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}
