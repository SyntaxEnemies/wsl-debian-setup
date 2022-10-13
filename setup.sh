#!/bin/bash
die() {
    printf "\033[1;31m%s\033[0m\n" "$1"
    exit 1
}
echo "$UID"
[[ "$UID" == "0" ]] || die "This script must be run with root priveleges."

[[ "$(cat /etc/*-release | grep "^NAME" | cut -d '=' -f 2 | tr "[:upper:]" "[:lower:]")" == *debian* ]] || die "This script must be run with debian."

declare -a pkgs
pkgs=( 'build-essential' 'libreadline-gplv2-dev' 'libncursesw5-dev' 'man-db' 'zip' 'unzip' 'wget' 'curl' 'tmux' 'neovim' 'ssh' 'locate' 'git' 'netcat' 'ranger' 'patch' 'tree' 'tar' 'bash-completion' )

echo "Commencing install for the following packages: "
printf "\t%s\n" "${pkgs[@]}"
echo

echo "(1/5) Updating package cache ..." && apt update &&\
echo "(2/5) Updating existing packages ..." && apt upgrade &&\
echo "(3/5) Installing new packages" && apt install "${pkgs[@]}"

echo "(4/5) Installing extras ..."

echo "Installing micro ..."
curl "https://getmic.ro" | bash
cp micro /usr/local/bin/micro

echo "Installing tmate ..."
cp tmate /usr/local/bin/

echo "Installing python ..."
wget https://www.python.org/ftp/python/3.10.7/Python-3.10.7.tgz
tar xzf Python-3.10.7.tgz
cd Python-3.10.7
./configure --enable-optimizations
make -j 2
make install

echo "Installing python-pip ..."
curl "https://bootstrap.pypa.io/get-pip" | python

echo "(5/5) Cloning project ..."
git clone https://github.com/SyntaxEnemies/power-com
