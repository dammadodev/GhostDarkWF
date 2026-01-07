#!/bin/bash

# --- Module: Crack ---

function start_crack() {
    echo -e "\n${BLUE}[*] Módulo de Cracking de Credenciales${NC}"
    
    echo "1) Cracking con Aircrack-ng (Rápido CPU)"
    echo "2) Cracking con Hashcat (GPU - Requiere conversión)"
    echo "3) Generar Diccionario con Crunch"
    echo "4) Volver"
    read subopt
    
    case $subopt in
        1)
            echo -e "${YELLOW}Ruta al archivo .cap: ${NC}"
            read cap_file
            echo -e "${YELLOW}Ruta al diccionario (wordlist): ${NC}"
            read wordlist
            aircrack-ng -w "$wordlist" "$cap_file"
            ;;
        2)
            echo -e "${YELLOW}Ruta al archivo .cap o .pcapng: ${NC}"
            read cap_file
            echo -e "${BLUE}[*] Convirtiendo a formato Hashcat (hcxpcapngtool)...${NC}"
            hcxpcapngtool -o "$LOGS/target.hc22000" "$cap_file"
            echo -e "${YELLOW}Ruta al diccionario: ${NC}"
            read wordlist
            hashcat -m 22000 "$LOGS/target.hc22000" "$wordlist"
            ;;
        3)
            echo -e "${YELLOW}Longitud mínima: ${NC}"
            read min
            echo -e "${YELLOW}Longitud máxima: ${NC}"
            read max
            echo -e "${YELLOW}Caracteres (ej: abcdef123): ${NC}"
            read chars
            echo -e "${YELLOW}Nombre del diccionario de salida: ${NC}"
            read out
            crunch "$min" "$max" "$chars" -o "$LOGS/$out"
            echo -e "${GREEN}[+] Diccionario generado en $LOGS/$out${NC}"
            ;;
        *) return ;;
    esac
}
