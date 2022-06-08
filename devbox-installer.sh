#!/bin/bash

{ # Prevent execution if this script was only partially downloaded

blue="\033[34m"
yellow="\033[33m"
green="\033[32m"
grey="\033[90m"
black="\033[0m"

generate_git_key() {
  if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo -e "Generating SSH key..."
    read -p "Enter your GitHub email: " github_email
    ssh-keygen -t rsa -C "$github_email" -N "" -f $HOME/.ssh/id_rsa -q
    echo ""
    exit 0
  fi

  chmod 400 $HOME/.ssh/id_rsa
  ssh-add $HOME/.ssh/id_rsa
}

validate_git_key() {
  echo -e "${yellow}Validating GitHub SSH key ~/.ssh/id_rsa ...${black}"

  if ! git ls-remote git@github.com:inkaviation/ink.devbox.git > /dev/null 2>&1; then
    err="~/.ssh/id_rsa is not associated yet with your GitHub "
    err+="account or you don't have permissions\n\n"
    echo -e "${yellow}${err}${black}"
    get_public_git_key
    exit 1
  fi

  echo -e "${green}SSH key ready to use!${black}"
  exit 0
}

get_public_git_key() {
  if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    ssh-keygen -y -f $HOME/.ssh/id_rsa >> $HOME/.ssh/id_rsa.pub
  fi

  printf "\033[32mGo to your Github account "
  printf "Settings > SSH and GPG keys section and add your SSH key pasting the public contents\n"
  printf "https://github.com/settings/ssh/new\033[0m\n"

  printf "\n\033[33mCopy the public key contents from here >>>>>\033[0m\n"
  cat $HOME/.ssh/id_rsa.pub
  printf "\033[33m<<<<< to here\033[0m\n"
}

fix_known_hosts() {
  touch $HOME/.ssh/known_hosts

  if ! grep -q "github.com" $HOME/.ssh/known_hosts; then
    ssh-keyscan github.com >> $HOME/.ssh/known_hosts
  fi
}

echo "get devbox"

# 1. Check Git SSH key
fix_known_hosts
generate_git_key
validate_git_key

while [ $? -ne 0 ]; do
  validate_git_key
done

# 2. Clone ink.devbox repo
echo "cloning repo"

} # End of wrapping
