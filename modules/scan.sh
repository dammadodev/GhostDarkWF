#!/bin/bash

# --- Module: Scan ---

function select_network() {
    local iface=$1
    echo -e "${BLUE}[*] Realizando escaneo rápido de 10 segundos para detectar redes...${NC}"
    
    # Archivo temporal para el escaneo
    local tmp_scan="/tmp/ghost_scan"
    rm -f "${tmp_scan}-01.csv"
    
    # Ejecutar airodump-ng en segundo plano por 10 segundos
    timeout 10s airodump-ng --write "$tmp_scan" --output-format csv "$iface" > /dev/null 2>&1
    
    if [[ ! -f "${tmp_scan}-01.csv" ]]; then
        echo -e "${RED}[!] Error al generar el archivo de escaneo.${NC}"
        return 1
    fi

    # Procesar CSV: Extraer BSSID, Canal, ESSID (omitiendo líneas vacías y encabezados)
    # El CSV de airodump tiene estaciones después de una línea en blanco, así que cortamos ahí.
    local selection=$(awk -F, '/BSSID/{y=1;next} /^$/{y=0} y{print $1 "," $4 "," $14}' "${tmp_scan}-01.csv" | \
        sed 's/ //g' | grep -v "^$" | \
        fzf --height 40% --reverse --header="Selecciona Objetivo: BSSID, CANAL, ESSID" --border)

    if [[ -z "$selection" ]]; then
        echo -e "${RED}[!] No se seleccionó ninguna red.${NC}"
        return 1
    fi

    # Exportar variables para que otros módulos las usen
    TARGET_BSSID=$(echo "$selection" | cut -d',' -f1)
    TARGET_CHANNEL=$(echo "$selection" | cut -d',' -f2)
    TARGET_ESSID=$(echo "$selection" | cut -d',' -f3)

    echo -e "${GREEN}[+] Objetivo Seleccionado: $TARGET_ESSID ($TARGET_BSSID) en Canal $TARGET_CHANNEL${NC}"
    rm -f "${tmp_scan}-"*
}

function start_scan() {
    echo -e "\n${BLUE}[*] Seleccionando Interfaz...${NC}"
    local iface=$(select_interface)
    
    if [[ -z "$iface" ]]; then return; fi

    echo -e "\n${BLUE}[*] ¿Deseas seleccionar un objetivo específico ahora? (s/n)${NC}"
    read -p "> " pick_opt
    
    if [[ "$pick_opt" == "s" ]]; then
        select_network "$iface"
    fi

    echo -e "\n${BLUE}[*] Iniciando entorno TMUX de monitoreo global...${NC}"
    
    SESSION_NAME="DarkGhostWf"
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux kill-session -t "$SESSION_NAME"
    fi

    tmux new-session -d -s "$SESSION_NAME" -n "Auditoria"
    tmux split-window -h -t "$SESSION_NAME"
    tmux split-window -v -t "$SESSION_NAME:0.0"
    tmux split-window -v -t "$SESSION_NAME:0.1"

    # Si hay objetivo seleccionado, enfocar el escaneo en él
    if [[ -n "$TARGET_BSSID" ]]; then
        tmux send-keys -t "$SESSION_NAME:0.0" "airodump-ng -c $TARGET_CHANNEL --bssid $TARGET_BSSID $iface" C-m
    else
        tmux send-keys -t "$SESSION_NAME:0.0" "airodump-ng $iface" C-m
    fi
    
    tmux send-keys -t "$SESSION_NAME:0.1" "echo 'Panel de ataque preparado para $TARGET_ESSID'" C-m
    tmux send-keys -t "$SESSION_NAME:0.2" "tail -f $LOGS/audit.log" C-m
    tmux send-keys -t "$SESSION_NAME:0.3" "watch -n 1 'awk \"NR==3 {print \\\"WiFi Link Qual: \\\" \\\$4 \\\"/70\\\"}\" /proc/net/wireless'" C-m

    tmux attach-session -t "$SESSION_NAME"
}
