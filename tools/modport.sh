NAME="modport"
DESC="Mod hub for all your games"

check() {
  command -v modport &>/dev/null
}

install() {
  uv tool install "git+ssh://git@github.com/PsychotronicG/modport.git"
}
