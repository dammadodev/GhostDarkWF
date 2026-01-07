#!/bin/bash

# --- DarkGhostWf Setup Script ---
# Installs necessary dependencies for Kali Linux

if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root"
   exit 1
fi

echo "[*] Actualizando repositorios..."
apt update

echo "[*] Instalando dependencias básicas..."
apt install -y aircrack-ng tmux nmap iw macchanger fzf hashcat crunch reaver bully wash mdk4 hcxdumptool hcxpcapngtool netdiscover

echo "[*] Configurando permisos..."
chmod +x main.sh
chmod +x modules/*.sh

echo -e "\n[+] Instalación completada. Ejecuta './main.sh' para empezar."
