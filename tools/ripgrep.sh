NAME="ripgrep"
DESC="Fast recursive search tool (rg)"
CATEGORY="search"
BINARY="rg"

check() { command -v rg &>/dev/null; }

install() { pkg_install ripgrep; }
