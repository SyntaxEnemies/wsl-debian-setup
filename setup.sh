#!/bin/bash
shellrc="$HOME/.bashrc"

die() {
    printf '\033[1;31m%s\033[0m\n' "$1"
    exit 1
}

[[ "$(cat /etc/*-release | grep '^NAME' | cut -d '=' -f 2 | tr '[:upper:]' '[:lower:]')" == *debian* ]] || die 'This script must be run with debian.'

declare -a pkgs
pkgs=( 'man-db' 'zip' 'unzip' 'wget' 'curl' 'tmux' 'neovim' 'ssh' 'locate' 'git' 'netcat' 'ranger' 'patch' 'tree' 'tar' 'bash-completion' 'make' 'libssl-dev' 'zlib1g-dev' 'libbz2-dev' 'libreadline-dev' 'libsqlite3-dev' 'llvm' 'libncursesw5-dev' 'xz-utils' 'tk-dev' 'libffi-dev' 'liblzma-dev' 'build-essential' 'libxml2-dev' 'libxmlsec1-dev')

echo 'Commencing install for the following packages: '
printf '\t%s\n' "${pkgs[@]}"
echo

echo '(1/5) Updating package cache ...' && sudo apt update &&\
echo '(2/5) Updating existing packages ...' && sudo apt upgrade &&\
echo '(3/5) Installing new packages' && sudo apt install "${pkgs[@]}"

echo '(4/5) Installing extras ...'

echo 'Installing micro ...'
curl 'https://getmic.ro' | bash
sudo cp micro /usr/local/bin/micro

echo 'Installing tmate ...'
sudo cp tmate /usr/local/bin/

echo 'Installing pyenv...'
if ! grep -q 'PYENV_ROOT' "$shellrc"; then
    echo "Adding pyenv information to shell bootstrap file: $shellrc"
    cat pyenv-fix.sh >> "$shellrc"
    source pyenv-fix.sh
fi

curl -L 'https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer' | bash
command -v pyenv &>/dev/null && 'Success with pyenv' || die "Couldn't install pyenv"

pyenv install --list | grep -E '^\s*[0-9]'
printf 'Python version to install: '
read py_version
echo

[[ -n "$py_version" ]] && (pyenv install "$py_version" && pyenv local "$py_version") || die 'No Python version selected, aborting ...'

echo 'Installing python-pip ...'
curl 'https://bootstrap.pypa.io/get-pip' | python

echo '(5/5) Cloning project ...'
git clone https://github.com/SyntaxEnemies/power-corp
