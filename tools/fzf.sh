NAME="fzf"
DESC="Fuzzy finder for the terminal"
CATEGORY="shell"

install() {
  pkg_install fzf || {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
  }
}
