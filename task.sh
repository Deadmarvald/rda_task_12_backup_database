#! /bin/bash
if [[ -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
    echo "Error: environment variables DB_USER and/or DB_PASSWORD not received"
    exit 1
fi

DB_NAME="ShopDB"
DB_BACKUP="ShopDBReserve"
DB_DEV="ShopDBDevelopment"
BACKUP_FILE="backup.sql"
DATA_BACKUP="data_backup.sql"

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --databases "$DB_NAME" > "$BACKUP_FILE"

mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_BACKUP" < "$BACKUP_FILE"

mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --no-create-info "$DB_NAME" > "$DATA_BACKUP"

mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_DEV" < "$DATA_BACKUP"

echo "TASK COMPLETED"