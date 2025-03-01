#!/bin/bash

function ctrl_c(){
  echo -e "\n[!] Saliendo..."
  tput cnorm
  exit 1
}

# Capturar Ctrl + C
trap ctrl_c INT 

# Validación de argumentos
if [ -z "$1" ]; then
  echo -e "\n[+] Uso: ./whichSystem.sh (ip)"
  exit 1
fi

tput civis
machine_ip=$1

ttl=$(ping -c 1 $machine_ip | awk '{print $6}' | tr '=' ' ' | grep -v "of" | awk '{print $2}' | xargs)


if [ -z "$ttl" ]; then
  echo -e "\n[+] No obtuvimos TTL de la máquina $machine_ip"
  tput cnorm
  exit 1
fi

# Determinar el sistema operativo según el TTL
if [ "$ttl" -le 64 ]; then
  echo -e "\n[+] $machine_ip -> Linux"
elif [ "$ttl" -gt 64 ] && [ "$ttl" -le 128 ]; then
  echo -e "\n[+] $machine_ip -> Windows"
else
  echo -e "\n[-] No se pudo determinar el sistema operativo"
fi

tput cnorm
