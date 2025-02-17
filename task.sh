#!/bin/bash

# Перевірка змінних оточення
if [[ -z "$DB_USER" || -z "$DB_PASSWORD" ]]; then
    echo "Error: environment variables DB_USER and/or DB_PASSWORD not set."
    exit 1
fi

DB_NAME="ShopDB"
DB_BACKUP="ShopDBReserve"
DB_DEV="ShopDBDevelopment"
BACKUP_FILE="/tmp/backup.sql"
DATA_BACKUP="/tmp/data_backup.sql"

# Повний бекап та відновлення у ShopDBReserve
echo "Creating full backup of $DB_NAME..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --databases "$DB_NAME" > "$BACKUP_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create full backup."
    exit 1
fi

echo "Restoring full backup to $DB_BACKUP..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_BACKUP" < "$BACKUP_FILE"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore full backup."
    exit 1
fi

# Бекап тільки даних (без створення таблиць) та відновлення у ShopDBDevelopment
echo "Creating data-only backup of $DB_NAME..."
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --no-create-info --replace "$DB_NAME" > "$DATA_BACKUP"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create data-only backup."
    exit 1
fi

echo "Restoring data backup to $DB_DEV..."
mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_DEV" < "$DATA_BACKUP"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to restore data-only backup."
    exit 1
fi

echo "TASK COMPLETED SUCCESSFULLY"