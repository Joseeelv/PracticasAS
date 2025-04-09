#!/bin/bash
# PGPASSWORD=$POSTGRES_PASSWORD pg_dump -U postgres postgres | gzip > /tmp/postgres-backup-$(date +%Y-%m-%d).sql.gz
touch /tmp/prueba.txt
RSYNC_PASSWORD=root rsync -avz --progress /tmp/prueba.txt rsync://root@172.20.0.2:873/backup

