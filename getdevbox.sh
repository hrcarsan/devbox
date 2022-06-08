#!/bin/bash

{ # Prevent execution if this script was only partially downloaded

blue="\033[34m"
yellow="\033[33m"
green="\033[32m"
grey="\033[90m"
black="\033[0m"
os=$(uname | tr '[:upper:]' '[:lower:]') # 'linux' or 'darwin'

generate_git_key() {
  echo -e "${blue}Generating SSH key...${black}"
  ssh-keygen -t rsa -C "" -N "" -f $HOME/.ssh/id_rsa -q
  echo -e "${green}Private ~/.ssh/id_rsa and public ~/.ssh/id_rsa.pub keys generated!${black}"
}

validate_git_key() {
  if ! git ls-remote git@github.com:inkaviation/ink.devbox.git > /dev/null 2>&1; then
    return 1
  fi
}

get_public_git_key() {
  if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    ssh-keygen -y -f $HOME/.ssh/id_rsa >> $HOME/.ssh/id_rsa.pub
  fi

  printf "${yellow}Go to your Github account "
  printf "Settings > SSH and GPG keys section and add your SSH key pasting the public contents\n"
  printf "https://github.com/settings/ssh/new${black}\n"

  printf "\n${yellow}Copy the public key contents from here >>>>>${black}\n"
  cat $HOME/.ssh/id_rsa.pub
  printf "${yellow}<<<<< to here${black}\n\n"
}

fix_known_hosts() {
  touch $HOME/.ssh/known_hosts

  if ! grep -q "github.com" $HOME/.ssh/known_hosts; then
    ssh-keyscan github.com >> $HOME/.ssh/known_hosts
  fi
}

# 1. Check Git SSH key
fix_known_hosts

if [ ! -f "$HOME/.ssh/id_rsa" ]; then
  generate_git_key
else
  chmod 400 $HOME/.ssh/id_rsa
  echo -e "${blue}Validating existing SSH key ~/.ssh/id_rsa...${black}\n"
fi

#if [ "$os" = "linux" ]; then
  #if ! ps -p "$SSH_AGENT_PID" > /dev/null 2>&1; then
    #eval `ssh-agent -s` > /dev/null 2>&1
  #fi
#fi

#ssh-add $HOME/.ssh/id_rsa > /dev/null 2>&1

validate_git_key

if [ $? -ne 0 ]; then
  get_public_git_key
  echo -e "${yellow}Also verify your GitHub account permissions with your supervisor${black}\n"

  echo -e "${blue}The installation will continue automatically after you associate the key and have the correct permissions${black}\n"

  false
  while [ $? -ne 0 ]; do
    sleep 5
    validate_git_key
  done
fi

echo -e "${green}Your GitHub SSH key ready to use!${black}"

# 2. Clone ink.devbox repo
echo "cloning repo"

} # End of wrapping - v1
