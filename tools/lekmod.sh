NAME="lekmod"
DESC="LekMod balance overhaul for Civ 5"

check() {
  [[ -f "${HOME}/.setup/.lekmod_version" ]]
}

install() {
  lekmod-update install
}
