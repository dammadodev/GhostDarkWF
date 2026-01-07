#!/bin/bash

# --- DarkGhostWf Setup Script ---
# Installs necessary dependencies for Kali Linux

if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root"
   exit 1
fi

# Ruta absoluta del proyecto
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colores para la salida del setup
GREEN='\033[0;32m'
YELLOW='\133[1;33m'
NC='\033[0m'

echo "[*] Actualizando repositorios..."
apt update

echo "[*] Instalando dependencias básicas..."
apt install -y aircrack-ng tmux nmap iw macchanger fzf hashcat crunch reaver bully wash mdk4 hcxdumptool hcxpcapngtool netdiscover

echo "[*] Configurando el comando global 'DarkGhostWf'..."
# Asegurarse de que el script principal sea ejecutable
chmod +x "$DIR/main.sh"
chmod +x "$DIR/modules/"*.sh

# Crear un enlace simbólico en /usr/local/bin
ln -sf "$DIR/main.sh" /usr/local/bin/DarkGhostWf

echo -e "\n${GREEN}[+] Instalación completada.${NC}"
echo -e "${YELLOW}[!] Ahora puedes ejecutar la herramienta desde cualquier lugar con: ${NC}sudo DarkGhostWf"
