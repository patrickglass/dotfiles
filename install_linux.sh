#!/bin/bash

set +u
set -e

SHELL_INIT_FILE="$HOME/.zshrc"

if [ -n "$ZSH_VERSION" ]; then
  # Zsh
  SHELL_INIT_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  # Bash
  SHELL_INIT_FILE="$HOME/.bashrc"
else
  echo "WARN: could not detect shell, falling back to .bashrc"
  SHELL_INIT_FILE="$HOME/.bashrc"
fi

set -u

function import_hashicorp_keys_trust {
  cat << EOF > "/tmp/hashicorp.asc"
  -----BEGIN PGP PUBLIC KEY BLOCK-----
  mQENBFMORM0BCADBRyKO1MhCirazOSVwcfTr1xUxjPvfxD3hjUwHtjsOy/bT6p9f
  W2mRPfwnq2JB5As+paL3UGDsSRDnK9KAxQb0NNF4+eVhr/EJ18s3wwXXDMjpIifq
  fIm2WyH3G+aRLTLPIpscUNKDyxFOUbsmgXAmJ46Re1fn8uKxKRHbfa39aeuEYWFA
  3drdL1WoUngvED7f+RnKBK2G6ZEpO+LDovQk19xGjiMTtPJrjMjZJ3QXqPvx5wca
  KSZLr4lMTuoTI/ZXyZy5bD4tShiZz6KcyX27cD70q2iRcEZ0poLKHyEIDAi3TM5k
  SwbbWBFd5RNPOR0qzrb/0p9ksKK48IIfH2FvABEBAAG0K0hhc2hpQ29ycCBTZWN1
  cml0eSA8c2VjdXJpdHlAaGFzaGljb3JwLmNvbT6JAU4EEwEKADgWIQSRpuf4XQXG
  VjC+8YlRhS2HNI/8TAUCXn0BIQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAK
  CRBRhS2HNI/8TJITCACT2Zu2l8Jo/YLQMs+iYsC3gn5qJE/qf60VWpOnP0LG24rj
  k3j4ET5P2ow/o9lQNCM/fJrEB2CwhnlvbrLbNBbt2e35QVWvvxwFZwVcoBQXTXdT
  +G2cKS2Snc0bhNF7jcPX1zau8gxLurxQBaRdoL38XQ41aKfdOjEico4ZxQYSrOoC
  RbF6FODXj+ZL8CzJFa2Sd0rHAROHoF7WhKOvTrg1u8JvHrSgvLYGBHQZUV23cmXH
  yvzITl5jFzORf9TUdSv8tnuAnNsOV4vOA6lj61Z3/0Vgor+ZByfiznonPHQtKYtY
  kac1M/Dq2xZYiSf0tDFywgUDIF/IyS348wKmnDGjuQENBFMORM0BCADWj1GNOP4O
  wJmJDjI2gmeok6fYQeUbI/+Hnv5Z/cAK80Tvft3noy1oedxaDdazvrLu7YlyQOWA
  M1curbqJa6ozPAwc7T8XSwWxIuFfo9rStHQE3QUARxIdziQKTtlAbXI2mQU99c6x
  vSueQ/gq3ICFRBwCmPAm+JCwZG+cDLJJ/g6wEilNATSFdakbMX4lHUB2X0qradNO
  J66pdZWxTCxRLomPBWa5JEPanbosaJk0+n9+P6ImPiWpt8wiu0Qzfzo7loXiDxo/
  0G8fSbjYsIF+skY+zhNbY1MenfIPctB9X5iyW291mWW7rhhZyuqqxN2xnmPPgFmi
  QGd+8KVodadHABEBAAGJATwEGAECACYCGwwWIQSRpuf4XQXGVjC+8YlRhS2HNI/8
  TAUCXn0BRAUJEvOKdwAKCRBRhS2HNI/8TEzUB/9pEHVwtTxL8+VRq559Q0tPOIOb
  h3b+GroZRQGq/tcQDVbYOO6cyRMR9IohVJk0b9wnnUHoZpoA4H79UUfIB4sZngma
  enL/9magP1uAHxPxEa5i/yYqR0MYfz4+PGdvqyj91NrkZm3WIpwzqW/KZp8YnD77
  VzGVodT8xqAoHW+bHiza9Jmm9Rkf5/0i0JY7GXoJgk4QBG/Fcp0OR5NUWxN3PEM0
  dpeiU4GI5wOz5RAIOvSv7u1h0ZxMnJG4B4MKniIAr4yD7WYYZh/VxEPeiS/E1CVx
  qHV5VVCoEIoYVHIuFIyFu1lIcei53VD6V690rmn0bp4A5hs+kErhThvkok3c
  =+mCN
  -----END PGP PUBLIC KEY BLOCK-----
EOF

  echo "INFO: Adding trust for HashiCorp GPG Key (91A6E7F85D05C65630BEF18951852D87348FFC4C)"
  gpg --dry-run --import --import-options import-show /tmp/hashicorp.asc
  gpg --import /tmp/hashicorp.asc
}

function install_hashicorp {
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  
  sudo apt-get -yq update
  sudo apt-get -yq install consul packer nomad vault waypoint boundary vagrant

  # require_homebrew_package tfenv

  wget https://github.com/starkandwayne/safe/releases/download/v1.7.0/safe-linux-amd64
  sudo install safe-linux-amd64 /usr/local/bin/safe
}

function install_go {
  sudo apt-get -yq install golang-go
}

function install_node {
  sudo apt-get -yq install nodejs npm yarn
}

function install_common_tools {
  sudo apt-get -yq update
  sudo apt-get -yq install make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
    git openssh-server htop gnupg vim neovim python3-neovim jq awscli
  
  echo "INFO: install python"
  sudo apt-get -yq install python3 python3-pip python3-virtualenv

#   require_homebrew_package pyenv
#   require_homebrew_package bat
#   require_homebrew_package gron
#   require_homebrew_package sshpass esolitos/ipa/sshpass
#   require_homebrew_package fzf
  # TODO: Install when we figure out shell profiles
  # echo 'eval "$(pyenv init -)"' >> "$SHELL_INIT_FILE"

#   if [ ! -f /usr/local/etc/bash_completion ]; then
#     brew install bash-completion
#     echo '[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"' >> "$SHELL_INIT_FILE"
#   fi
}

function install_git {
  sudo add-apt-repository -y ppa:git-core/ppa
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get -yq update
  sudo apt-get -yq install git git-lfs gh

  git lfs install

  if [ ! -f "$HOME/.gitconfig" ]; then
    git config --global credential.helper store
    if [ "$USER" = "pglas" ]; then
      git config --global user.name "Patrick Glass"
      git config --global user.email "patrickglass@gmail.com"
    fi
  fi
}

function install_docker {
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get -yq update
  sudo apt-get -yq install docker-ce docker-ce-cli containerd.io
  sudo usermod -aG docker vagrant
}

function install_k8s {

  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  echo "$(<kubectl.sha256) kubectl" | sha256sum --check
  sudo install kubectl /usr/local/bin/kubectl

  # TODO
  # require_homebrew
  # require_homebrew_package kubectx
  # require_homebrew_package kind
  # require_homebrew_package k3d
  # require_homebrew_package minikube
  # require_homebrew_package k9s
  # require_homebrew_package helm
  # require_homebrew_package velero
}

function install_vscode {
  # TODO
  # require_homebrew_package code homebrew/cask/visual-studio-code
}

function install_profiles {
  [ -x "$HOME/.hal_aliases.sh" ] || cp -pr "./hal_aliases.sh" "$HOME/.hal_aliases.sh"
  [ -x "$HOME/.hal_functions.sh" ] || cp -pr "./hal_functions.sh" "$HOME/.hal_functions.sh"
  [ -x "$HOME/.hal_kubectl.sh" ] || cp -pr "./hal_kubectl.sh" "$HOME/.hal_kubectl.sh"
  [ -x "$HOME/.hal_profile.sh" ] || cp -pr "./hal_profile.sh" "$HOME/.hal_profile.sh"

  if grep -Fq ".hal_profile.sh" "$SHELL_INIT_FILE" ;
  then
    echo "INFO: .hal_profile is already injected into $SHELL_INIT_FILE"
  else
    echo "INFO: adding .hal_profile to $SHELL_INIT_FILE"
    echo "# HAL Development Environment Profile" >> "$SHELL_INIT_FILE"
    echo "# https://github.com/patrickglass/devenv" >> "$SHELL_INIT_FILE"
    echo "[ -r \"$HOME/.hal_profile.sh\" ] && . \"$HOME/.hal_profile.sh\"" >> "$SHELL_INIT_FILE"
  fi
}

function addline {
  local PATTERN="$1"
  local LINE="$2"
  local FILE="$3"

  if ! grep -E -q "${PATTERN}" "${FILE}" ;
  then
    echo "WARN: adding line: $LINE to $FILE"
    echo "$LINE" >> "$FILE"
  fi
}

function prompt {
  COMMAND="$*"
  echo "Planning to run: $COMMAND"
  read -p "Are you sure? " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    eval "$COMMAND"
  fi
}

function show_help {
  echo "###############################################################################"
  echo "#                    Patrick Development Environment Setup                    #"
  echo "###############################################################################"
  echo ""
  echo "  Usage:"
  echo "    ./install.sh --help       # Create a test cluster"
  echo "    ./install.sh clean        # Cleanup installed files"
  echo "    ./install.sh              # Run installer wizard"
  echo "    ./install.sh <component>  # Run installer for specific component"
  echo ""
  echo "  Eg. ./install.sh git"
}

function main {
  COMMAND=$1

  if [ "$COMMAND" = "--help" ]; then
    show_help
  elif [ "$COMMAND" = "clean" ]; then
    rm -rf \
      "$HOME/.hal_aliases.sh" \
      "$HOME/.hal_functions.sh" \
      "$HOME/.hal_kubectl.sh" \
      "$HOME/.hal_profile.sh"
    sed -i '' '/\.profile\.sh/d' "${SHELL_INIT_FILE}"
    sed -i '' '/\.hal_profile\.sh/d' "${SHELL_INIT_FILE}"
    sed -i '' '/^# HAL Development/d' "${SHELL_INIT_FILE}"
    sed -i '' '/patrickglass\/devenv/d' "${SHELL_INIT_FILE}"
  elif [ "$COMMAND" = "hashicorp" ]; then
    install_hashicorp
  elif [ "$COMMAND" = "common_tools" ]; then
    install_common_tools
  elif [ "$COMMAND" = "git" ]; then
    install_git
  elif [ "$COMMAND" = "go" ]; then
    install_go
  elif [ "$COMMAND" = "node" ]; then
    install_node
  elif [ "$COMMAND" = "docker" ]; then
    install_docker
  elif [ "$COMMAND" = "k8s" ]; then
    install_k8s
  elif [ "$COMMAND" = "vscode" ]; then
    install_vscode
  elif [ "$COMMAND" = "profiles" ]; then
    install_profiles
  else
    echo "INFO: starting install wizard."
    prompt install_common_tools
    prompt install_profiles
    prompt install_git
    # prompt import_hashicorp_keys_trust
    prompt install_hashicorp
    prompt install_go
    prompt install_docker
    prompt install_k8s
    prompt install_vscode
  fi
  echo "INFO: install completed."
}

# Run the main entrypoint
main "$@"
