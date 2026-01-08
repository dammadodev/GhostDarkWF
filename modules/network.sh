#!/bin/bash

# --- Module: Network & Interfaces ---

function select_interface() {
    local interfaces=$(iw dev | grep Interface | awk '{print $2}')
    if [[ -z "$interfaces" ]]; then
        echo -e "${RED}[!] No se detectaron interfaces inalámbricas.${NC}"
        return 1
    fi
    
    echo -e "$interfaces" | fzf --height 40% --reverse --header="Selecciona la interfaz inalámbrica:" --border
}

function manage_interfaces() {
    echo -e "\n${BLUE}[*] Escaneando Interfaces Inalámbricas...${NC}"
    local iface=$(select_interface)
    
    if [[ -z "$iface" ]]; then
        echo -e "${RED}[!] Selección cancelada.${NC}"
        sleep 1
        return
    fi
    
    echo -e "\n${BLUE}[*] Interfaz seleccionada: ${YELLOW}$iface${NC}"
    echo "1) Iniciar Modo Monitor (airmon-ng)"
    echo "2) Detener Modo Monitor"
    echo "3) Cambiar MAC Address (Anonimato)"
    echo "4) Volver"
    read -p "Opcion: " subopt
    
    case $subopt in
        1)
            airmon-ng check kill
            airmon-ng start "$iface"
            echo -e "${GREEN}[+] Modo monitor activado.${NC}"
            sleep 2
            ;;
        2)
            # Intentar detener tanto el nombre original como el nombre monitor (wlan0mon)
            airmon-ng stop "$iface" 2>/dev/null
            echo -e "${GREEN}[+] Intento de detener modo monitor finalizado.${NC}"
            service networking restart
            sleep 2
            ;;
        3)
            ip link set "$iface" down
            macchanger -r "$iface"
            ip link set "$iface" up
            echo -e "${GREEN}[+] MAC cambiada aleatoriamente.${NC}"
            sleep 2
            ;;
        *) return ;;
    esac
}

function internal_recon() {
    echo -e "\n${BLUE}[*] Reconocimiento de Red Interna${NC}"
    echo -e "${YELLOW}Objetivo (Rango IP, ej: 192.168.1.0/24): ${NC}"
    read target
    
    echo "1) Escaneo rápido (Nmap -F)"
    echo "2) Detección de OS y Servicios (Nmap -A)"
    echo "3) Escaneo pasivo (Netdiscover)"
    read subopt
    
    # Aquí podríamos usar TMUX para mostrar resultados en otro panel si quisiéramos
    case $subopt in
        1) nmap -F "$target" ;;
        2) nmap -A "$target" ;;
        3) netdiscover -r "$target" ;;
        *) return ;;
    esac
    
    echo -e "\n${GREEN}Escaneo finalizado. Presione Enter para continuar...${NC}"
    read
}
