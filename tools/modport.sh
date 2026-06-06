NAME="modport"
DESC="Mod hub for all your games"
CATEGORY="apps"

check() {
  command -v modport &>/dev/null
}

install() {
  uv tool install "git+ssh://git@github.com/PsychotronicG/modport.git"
}
