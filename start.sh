#!/bin/sh
set -e

# Função para verificar se os serviços necessários estão disponíveis
check_service() {
    local host=$1
    local port=$2
    local service=$3
    echo "Waiting for $service to be ready..."
    while ! nc -z $host $port; do
        echo "Waiting for $service..."
        sleep 1
    done
    echo "$service is ready!"
}

# Verificar PostgreSQL
check_service postgres 5432 "PostgreSQL"

# Verificar Redis (se estiver usando)
check_service redis 6379 "Redis"

# Verificar MinIO (se estiver usando)
check_service minio 9000 "MinIO"

# Run migrations
echo "Running database migrations..."
pnpm run db:migrate || {
    echo "Failed to run migrations"
    exit 1
}

# Start the application
echo "Starting the application..."
exec pnpm start
