#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n${redColour}[!] Saliendo...${endColour}"
  tput cnorm
  exit 1
}

# Capturar Ctrl + C
trap ctrl_c INT 

# Validación de argumentos
if [ -z "$1" ]; then
  echo -e "\n${blueColour}[+]${endColour} ${turquoiseColour}Uso: ./whichSystem.sh \"ip\"${endColour}"
  exit 1
fi

tput civis
machine_ip=$1

ttl=$(ping -c 1 $machine_ip | awk '{print $6}' | tr '=' ' ' | grep -v "of" | awk '{print $2}' | xargs)


if [ -z "$ttl" ]; then
  echo -e "\n${redColour}[-] No obtuvimos TTL de la máquina $machine_ip ${endColour}"
  tput cnorm
  exit 1
fi

# Determinar el sistema operativo según el TTL

if [ "$ttl" -le 64 ]; then
  echo -e "\n${greenColour}[+]${endColour} ${purpleColour}$machine_ip -> Linux${endColour}"
elif [ "$ttl" -gt 64 ] && [ "$ttl" -le 128 ]; then
  echo -e "\n${greenColour}[+]${endColour} ${purpleColour}$machine_ip -> Windows${endColour}"
else
  echo -e "\n${redColour}[-] No se pudo determinar el sistema operativo${endColour}"
fi

tput cnorm
