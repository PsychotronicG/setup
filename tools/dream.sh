NAME="dream"
DESC="Dream journal CLI"

check() {
  command -v dream &>/dev/null
}

install() {
  uv tool install "git+ssh://git@github.com/PsychotronicG/dream.git"
}
