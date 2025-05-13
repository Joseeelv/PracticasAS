#!/bin/bash

# Script para inicializar y arrancar el servidor FTP vsftpd
# Este script verifica que todos los directorios y archivos necesarios
# existan y tengan los permisos correctos antes de iniciar el servicio.

# Función para escribir mensajes de log
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1"
}

log_message "Iniciando script de configuración para vsftpd..."

# 1. Verificar directorios necesarios
DIRS_TO_CHECK=(
    "/ftp"
    "/ftp/publico"
    "/var/run/vsftpd/empty"
    "/etc/ssl/private"
    "/etc/ssl/certs"
    "/var/log"
)

log_message "Verificando directorios requeridos..."
for dir in "${DIRS_TO_CHECK[@]}"; do
    if [ ! -d "$dir" ]; then
        log_message "Creando directorio $dir"
        mkdir -p "$dir"
    fi
    
    # Asegurar permisos correctos
    chmod 755 "$dir"
    log_message "Permisos establecidos correctamente para $dir"
done

# 2. Verificar archivos necesarios
# Verificar certificados SSL
if [ ! -f "/etc/ssl/private/vsftpd.key" ] || [ ! -f "/etc/ssl/certs/vsftpd.pem" ]; then
    log_message "Generando certificados SSL nuevos..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/vsftpd.key \
        -out /etc/ssl/certs/vsftpd.pem \
        -subj "/C=ES/ST=Cadiz/L=Cadiz/O=UCA/CN=dev.practicasas.local"
    
    chmod 600 /etc/ssl/private/vsftpd.key
    chmod 644 /etc/ssl/certs/vsftpd.pem
    log_message "Certificados SSL generados correctamente"
fi

# Verificar archivo de configuración
if [ ! -f "/etc/vsftpd.conf" ]; then
    log_message "ERROR: No se encuentra el archivo de configuración /etc/vsftpd.conf"
    exit 1
fi

# Verificar userlist
if [ ! -f "/etc/vsftpd.userlist" ]; then
    log_message "Creando archivo userlist..."
    echo "ftpuser" > /etc/vsftpd.userlist
    chmod 644 /etc/vsftpd.userlist
fi

# 3. Asegurar que el archivo de log existe y tiene permisos correctos
touch /var/log/vsftpd.log
chmod 644 /var/log/vsftpd.log
log_message "Archivo de log preparado en /var/log/vsftpd.log"

# 4. Verificar usuario FTP
if ! id -u ftpuser &>/dev/null; then
    log_message "Creando usuario FTP..."
    useradd -m ftpuser -s /bin/bash
    echo "ftpuser:ftppass" | chpasswd
    usermod -d /ftp ftpuser
fi

# Asegurar permisos correctos para directorio FTP
chown -R ftpuser:ftpuser /ftp
log_message "Permisos de directorio FTP establecidos correctamente"

# Verificar archivo de ejemplo
if [ ! -f "/ftp/publico/README.txt" ]; then
    echo "Bienvenido al servidor FTP de Desarrollo" > /ftp/publico/README.txt
    chown ftpuser:ftpuser /ftp/publico/README.txt
fi

# 5. Comprobar disponibilidad del puerto 21
if netstat -tnl | grep -q ':21 '; then
    log_message "ADVERTENCIA: El puerto 21 ya está en uso. Verificar si hay otro servicio FTP ejecutándose."
fi

# 6. Mostrar información de depuración
log_message "Configuración de vsftpd:"
grep -v "^#" /etc/vsftpd.conf | grep -v "^$"

log_message "Usuario FTP configurado:"
grep "ftpuser" /etc/passwd

log_message "Todas las comprobaciones completadas. Iniciando vsftpd..."

# 7. Iniciar vsftpd en primer plano
exec vsftpd /etc/vsftpd.conf

