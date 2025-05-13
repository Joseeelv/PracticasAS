#!/bin/bash

# Log file for the tunnel script
LOG_FILE="/var/log/tunnel.log"

# Variables de configuración
DEV_HOST="172.40.0.2"  # IP del contenedor dev
DEV_FTP_PORT="21"      # Puerto FTP en el servidor dev
LOCAL_FTP_PORT="2121"  # Puerto local para la redirección

# Función para escribir mensajes de log
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Función para escribir mensajes de error
log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" | tee -a $LOG_FILE
}

# Función para escribir mensajes de debug
log_debug() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - DEBUG: $1" | tee -a $LOG_FILE
}

# Crear el archivo de log si no existe
touch $LOG_FILE
log_message "Iniciando script de redirección de puertos..."

# Asegurarse de que el /etc/hosts tenga la entrada correcta
grep -q "172.40.0.2 servidor_dev" /etc/hosts || echo "172.40.0.2 servidor_dev" >> /etc/hosts
log_message "Configuración de /etc/hosts actualizada"

# Verificar si netcat está instalado
if ! command -v nc &> /dev/null; then
    log_message "ERROR: Netcat (nc) no está instalado. Instalando..."
    apt-get update && apt-get install -y netcat-openbsd
    
    if [ $? -ne 0 ]; then
        log_message "ERROR: No se pudo instalar netcat. Saliendo."
        exit 1
    fi
    
    log_message "Netcat instalado correctamente."
fi

# Verificar si el usuario tiene permisos de root
if [ "$(id -u)" != "0" ]; then
    log_message "Este script se está ejecutando como usuario no root, puede haber problemas de permisos"
fi

# Verificar si el puerto está disponible
check_port_available() {
    local port=$1
    if netstat -tuln | grep -q ":${port} "; then
        log_error "El puerto ${port} ya está en uso"
        return 1
    fi
    return 0
}

# Función para probar conectividad con el host destino
test_connectivity() {
    log_debug "Probando conectividad con ${DEV_HOST}:${DEV_FTP_PORT}..."
    
    timeout 5 nc -z ${DEV_HOST} ${DEV_FTP_PORT} &>/dev/null
    if [ $? -ne 0 ]; then
        log_error "No se pudo conectar a ${DEV_HOST}:${DEV_FTP_PORT}"
        return 1
    fi
    
    log_debug "Conectividad con ${DEV_HOST}:${DEV_FTP_PORT} verificada"
    return 0
}

# Función para mantener el túnel activo usando SSH
start_tunnel() {
    log_message "Estableciendo redirección de puerto ${LOCAL_FTP_PORT} a ${DEV_HOST}:${DEV_FTP_PORT} usando SSH..."
    
    # Verificar si el puerto está disponible
    if ! check_port_available ${LOCAL_FTP_PORT}; then
        log_error "No se puede iniciar el túnel porque el puerto ${LOCAL_FTP_PORT} no está disponible"
        return 1
    fi
    
    # Iniciar el túnel SSH en segundo plano
    ssh -N -L ${LOCAL_FTP_PORT}:${DEV_HOST}:${DEV_FTP_PORT} user@remote_host &
    SSH_TUNNEL_PID=$!
    
    # Verificar si el túnel SSH se inició correctamente
    if ! ps -p ${SSH_TUNNEL_PID} > /dev/null; then
        log_error "No se pudo iniciar el túnel SSH."
        return 1
    fi
    
    log_message "Túnel SSH iniciado con PID: ${SSH_TUNNEL_PID}"
    echo ${SSH_TUNNEL_PID} > /var/run/tunnel.pid
}

# Verificar si el túnel ya está en ejecución
if [ -f /var/run/tunnel.pid ]; then
    OLD_PID=$(cat /var/run/tunnel.pid)
    if ps -p ${OLD_PID} > /dev/null; then
        log_message "El túnel ya está en ejecución con PID: ${OLD_PID}. Deteniéndolo..."
        kill ${OLD_PID}
    fi
    rm /var/run/tunnel.pid
fi

# Iniciar el túnel
log_message "Iniciando túnel de redirección de puertos..."
start_tunnel

# Verificar si el túnel se inició correctamente
sleep 2
if [ -f /var/run/tunnel.pid ]; then
    TUNNEL_PID=$(cat /var/run/tunnel.pid)
    if ps -p ${TUNNEL_PID} > /dev/null; then
        log_message "Script de redirección inicializado correctamente con PID ${TUNNEL_PID}"
        
        # Mostrar estado de los puertos
        log_debug "Estado de los puertos después de iniciar el túnel:"
        netstat -tuln | grep -e ":${
