# 👻 DarkGhostWf - Advanced Wi-Fi Auditing Tool

**DarkGhostWf** es una herramienta de auditoría inalámbrica modular y automatizada diseñada para profesionales de la ciberseguridad. Optimiza y orquesta las mejores herramientas de la suite Aircrack-ng, Bettercap, Hashcat y más, todo dentro de un entorno de terminal enriquecido con `tmux`.

## 🎯 Objetivo del Proyecto
Facilitar la ejecución de pruebas de penetración inalámbricas autorizadas mediante una interfaz CLI intuitiva, organizada y potente.

## 🛠️ Herramientas Integradas
*   **Suite Aircrack-ng:** airmon-ng, airodump-ng, aireplay-ng, aircrack-ng.
*   **Wireless Advanced:** hcxdumptool, hcxpcapngtool, mdk4, wash, reaver.
*   **Network Recon:** nmap, netdiscover, arp-scan.
*   **Cracking:** hashcat, john, crunch.
*   **Interacción:** tmux, fzf, jq.

## 📂 Estructura del Proyecto
```text
DarkGhostWf/
├── main.sh             # Script principal y orquestador
├── modules/            # Lógica modular por funcionalidad
│   ├── scan.sh         # Escaneo y enumeración
│   ├── capture.sh      # Captura de handshakes y PMKID
│   ├── crack.sh        # Ataques de diccionario y cracking
│   ├── network.sh      # Escaneo de red interna post-conexión
│   └── advanced.sh     # Mdk4, WPS, etc.
├── tmux/               # Configuraciones de layout
├── logs/               # Almacenamiento de evidencias
└── README.md           # Documentación
```

## 🚀 Instalación y Uso
1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/usuario/DarkGhostWf.git
    cd DarkGhostWf
    ```
2.  **Otorgar permisos:**
    ```bash
    chmod +x main.sh modules/*.sh
    ```
3.  **Ejecutar:**
    ```bash
    sudo ./main.sh
    ```

## 🔐 Ética y Legalidad
Esta herramienta ha sido creada exclusivamente para fines de **educación y auditorías de seguridad autorizadas**. El uso de esta herramienta contra redes sin permiso explícito es ilegal y poco ético. El autor no se hace responsable del mal uso de este software.

---
*Desarrollado para Kali Linux con ❤️ y Bash.*
