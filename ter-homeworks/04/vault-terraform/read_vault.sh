#!/bin/bash
# Читаем секрет по пути secret/example из Vault API
TOKEN="education"
VAULT_ADDR="http://127.0.0.1:8200"
SECRET_PATH="secret/data/example"

response=$(curl -s -H "X-Vault-Token: $TOKEN" "$VAULT_ADDR/v1/$SECRET_PATH")
# Извлекаем data.data и выводим как JSON
echo "$response" | jq -c '{test: .data.data.test}'
