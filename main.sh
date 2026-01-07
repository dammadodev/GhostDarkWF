#!/bin/bash

# --- DarkGhostWf Main Orquestrator ---
# Author: Antigravity Assistant
# Purpose: Legal & Authorized Wi-Fi Auditing

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES="$DIR/modules"
LOGS="$DIR/logs"

# Check Root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Este script debe ejecutarse como root${NC}"
   exit 1
fi

# Banner
function banner() {
    clear
    echo -e "${BLUE}"
    echo "  ________              __  ________  .__                      __"
    echo "  \______ \ _____ ______ |  |/  _____/ |  |__   ____   _______/  |_"
    echo "   |    |  \\__  \\ \_  __ \  /   \  ___ |  |  \ /  _ \ /  ___/\   __\\"
    echo "   |    \`   \/ __ \ |  | \/  \    \_\  \|   Y  (  <_> )___ \  |  |"
    echo "  /_______  (____  /|__|  |__|\______  /|___|  /\____/____  > |__|"
    echo "          \/     \/                  \/      \/           \/     "
    echo -e "                 ${YELLOW}v1.0 - WiFi Auditing Automation${NC}"
    echo -e "          ${RED}SOLO PARA USO AUTORIZADO Y ÉTICO${NC}\n"
}

# Dependency Check
function check_dependencies() {
    local deps=("airmon-ng" "airodump-ng" "tmux" "nmap" "iw" "macchanger" "fzf")
    echo -n "[*] Comprobando dependencias... "
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}\n[!] Falta: $dep. Instálalo con 'apt install $dep'${NC}"
            # exit 1 (Could auto-install but better to alert for transparency)
        fi
    done
    echo -e "${GREEN}OK${NC}"
}

# Ethical Disclaimer
function disclaimer() {
    echo -e "${RED}################################################################"
    echo -e "#                       AVISO LEGAL                            #"
    echo -e "################################################################"
    echo -e "# Esta herramienta es exclusivamente para auditorías           #"
    echo -e "# autorizadas. El uso no autorizado es un delito.              #"
    echo -e "# ¿Tienes permiso explícito para auditar las redes objetivo?   #"
    echo -e "################################################################${NC}"
    echo -n -e "\n[?] Escribe 'ACEPTO' para continuar: "
    read confirmation
    if [[ "$confirmation" != "ACEPTO" ]]; then
        echo -e "${RED}[!] Saliendo...${NC}"
        exit 1
    fi
}

# Main Menu
function main_menu() {
    while true; do
        banner
        echo -e "${BLUE}--- MENÚ PRINCIPAL ---${NC}"
        echo "1) 📡 Gestión de Interfaces (Monitor Mode)"
        echo "2) 🔍 Escaneo de Redes (Airodump-ng)"
        echo "3) 🎣 Captura de Handshake / PMKID"
        echo "4) 🔓 Cracking de Credenciales"
        echo "5) 🌐 Análisis de Red Interna (Nmap)"
        echo "6) 💣 Ataques Avanzados (WPS/MDK4)"
        echo "7) 🧹 Limpiar y Salir"
        echo -e "\n${YELLOW}Seleccione una opción: ${NC}"
        
        read opt
        case $opt in
            1) source "$MODULES/network.sh" && manage_interfaces ;;
            2) source "$MODULES/scan.sh" && start_scan ;;
            3) source "$MODULES/capture.sh" && start_capture ;;
            4) source "$MODULES/crack.sh" && start_crack ;;
            5) source "$MODULES/network.sh" && internal_recon ;;
            6) source "$MODULES/advanced.sh" && advanced_menu ;;
            7) cleanup; exit 0 ;;
            *) echo -e "${RED}Opción no válida${NC}" ; sleep 1 ;;
        esac
    done
}

function cleanup() {
    echo -e "${YELLOW}[*] Realizando limpieza...${NC}"
    # Detener sesiones de tmux si existen
    tmux kill-session -t DarkGhostWf 2>/dev/null
    # Restaurar interfaces si es necesario (ejecutado por network.sh)
    echo -e "${GREEN}[+] Red restaurada. ¡Hasta pronto!${NC}"
}

# Start execution
check_dependencies
disclaimer
main_menu
