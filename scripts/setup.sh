#!/bin/bash

#formatting stuff
bold=$(tput bold)
underline=$(tput smul)
normal=$(tput sgr0)
standout=$(tput smso)
blink=$(tput blink)


red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

enable_interfaces(){
  #enable spi
  sudo sed -i 's/^dtparam=spi=.*/dtparam=spi=on/' /boot/config.txt
  sudo sed -i 's/^#dtparam=spi=.*/dtparam=spi=on/' /boot/config.txt
  print_success "SPI Interface has been enabled."
  #enable i2c
  sudo sed -i 's/^dtparam=i2c_arm=.*/dtparam=i2c_arm=on/' /boot/config.txt
  sudo sed -i 's/^#dtparam=i2c_arm=.*/dtparam=i2c_arm=on/' /boot/config.txt
  print_success "I2C Interface has been enabled.\n"
}


show_loader() {
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  printf "$1 [${spinstr:0:1}] "
  while ps a | awk '{print $1}' | grep -q "${pid}"; do
    local temp=${spinstr#?}
    printf "\r$1 [${temp:0:1}] "
    spinstr=${temp}${spinstr%"${temp}"}
    sleep ${delay}
  done
  if [[ $? -eq 0 ]]; then
    printf "\r$1 [\e[32m\xE2\x9C\x94\e[0m]\n"
  else
    printf "\r$1 [\e[31m\xE2\x9C\x98\e[0m]\n"
  fi
}


#status funcs
print_header() {
  echo -e "${bold}${underline}$1${normal}"
}

print_standout() {
  echo -e "${standout}$1${normal}"
}

print_blink() {
  echo -e "${blink}$1${normal}"
}

print_bold() {
  echo -e "${bold}$1${normal}"
}

print_underline() {
  echo -e "${underline}$1${normal}"
}


print_success() {
  echo -e "${green}$1${normal}"
}

print_error() {
  echo -e "${red}$1${normal}"
}

# better color vals than tput
print_warn() {
  echo -e "\e[38;2;255;255;0m$1\e[0m"

}

print_blue() {
  echo -e "\e[38;2;65;105;225m$1\e[0m"
}


# Set the current  and ip
currentDir=$(dirname "$PWD")
currentWorkingDir=$(pwd)
currentFolder=${PWD##*/} 
ipAddress=$(hostname -I | cut -d ' ' -f 1)

# do a sudo check!
if [ "$EUID" -ne 0 ]; then
  echo -e "\n[ERROR]: $(print_error "The PiInk installation script requires root privileges. Please run it with sudo.\n")"
  exit 1
fi

if [ "$currentFolder" == "scripts" ]; then
  cd ..
  currentDir=$(pwd)
  currentWorkingDir=$(pwd)
fi