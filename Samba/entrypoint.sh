#!/bin/bash

# Crear estructura de carpetas
for dir in desarrollo revision publico; do
    mkdir -p /samba/$dir
    for i in {1..5}; do
        mkdir -p /samba/$dir/SW$i
    done
done

# Crear usuarios del sistema y de Samba
for i in {1..5}; do
    useradd -M -s /sbin/nologin empleado$i || true
    echo -e "pass$i\npass$i" | smbpasswd -a -s empleado$i
done

useradd -M -s /sbin/nologin revisor || true
echo -e "revisorpass\nrevisorpass" | smbpasswd -a -s revisor

# Asignar permisos adecuados
for i in {1..5}; do
    chown -R empleado$i:nogroup /samba/desarrollo/SW$i
    chmod -R 770 /samba/desarrollo/SW$i

    chown -R empleado$i:nogroup /samba/revision/SW$i
    chmod -R 770 /samba/revision/SW$i
done

# Permisos para publico
chown -R revisor:nogroup /samba/publico
chmod -R 775 /samba/publico

# Lanzar Samba
exec smbd -F --no-process-group
