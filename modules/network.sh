#!/bin/bash

# --- Module: Network & Interfaces ---

function manage_interfaces() {
    echo -e "\n${BLUE}[*] Interfaces Inalámbricas Disponibles:${NC}"
    iw dev | grep Interface | awk '{print $2}'
    
    echo -e "\n${YELLOW}Nombre de la interfaz (ej: wlan0): ${NC}"
    read iface
    
    echo "1) Iniciar Modo Monitor"
    echo "2) Detener Modo Monitor"
    echo "3) Cambiar MAC Address (Anonimato)"
    echo "4) Volver"
    read subopt
    
    case $subopt in
        1)
            airmon-ng check kill
            airmon-ng start "$iface"
            echo -e "${GREEN}[+] Modo monitor activado en ${iface}${NC}"
            sleep 2
            ;;
        2)
            airmon-ng stop "${iface}mon" 2>/dev/null || airmon-ng stop "$iface"
            echo -e "${GREEN}[+] Modo monitor desactivado${NC}"
            service networking restart
            service wpa_supplicant restart
            sleep 2
            ;;
        3)
            ip link set "$iface" down
            macchanger -r "$iface"
            ip link set "$iface" up
            echo -e "${GREEN}[+] MAC cambiada aleatoriamente${NC}"
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
