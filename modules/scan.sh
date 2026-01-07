#!/bin/bash

# --- Module: Scan ---

function start_scan() {
    echo -e "\n${BLUE}[*] Configurando Entorno de Escaneo...${NC}"
    echo -e "${YELLOW}Interfaz en modo monitor: ${NC}"
    read iface
    
    # Crear sesión de tmux personalizada
    SESSION_NAME="DarkGhostWf"
    
    if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
        tmux kill-session -t "$SESSION_NAME"
    fi

    # Iniciar sesión y paneles
    tmux new-session -d -s "$SESSION_NAME" -n "Auditoria"
    
    # Dividir paneles
    tmux split-window -h -t "$SESSION_NAME" # Divide horizontal (L-R)
    tmux split-window -v -t "$SESSION_NAME:0.0" # Divide vertical el panel izq
    tmux split-window -v -t "$SESSION_NAME:0.1" # Divide vertical el panel der

    # Panel 0 (Top-Left): Escaneo de Redes
    tmux send-keys -t "$SESSION_NAME:0.0" "airodump-ng $iface" C-m
    
    # Panel 1 (Bottom-Left): Captura / Aireplay-ng (Placeholder)
    tmux send-keys -t "$SESSION_NAME:0.1" "echo 'Esperando objetivo para deauth/captura...'" C-m
    
    # Panel 2 (Top-Right): Logs
    tmux send-keys -t "$SESSION_NAME:0.2" "tail -f $LOGS/audit.log" C-m
    
    # Panel 3 (Bottom-Right): Estado del Sistema / WIP
    tmux send-keys -t "$SESSION_NAME:0.3" "watch -n 1 'awk \"NR==3 {print \\\"WiFi Link Qual: \\\" \\\$4 \\\"/70\\\"}\" /proc/net/wireless'" C-m

    echo -e "${GREEN}[+] Sesión TMUX iniciada.${NC}"
    echo -e "${YELLOW}[!] Use 'tmux attach-session -t $SESSION_NAME' para ver la actividad.${NC}"
    echo -e "${YELLOW}[!] Use 'Ctrl-b d' para salir del visualizador pero mantener el escaneo.${NC}"
    sleep 3
    
    tmux attach-session -t "$SESSION_NAME"
}
