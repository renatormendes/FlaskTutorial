#!/bin/bash

# Verifica se uma mensagem de commit foi passada como argumento
# Caso contrário, usa uma mensagem padrão com a data atual
MENSAGEM=${1:-"Update: $(date +'%d/%m/%Y %H:%M:%S')"}

echo "🚀 Iniciando o envio para o GitHub..."

# Iniciando o Git
git init

# Adiciona todos os arquivos (respeitando o .gitignore)
git add .

# Faz o commit com a mensagem definida
git commit -m "$MENSAGEM"

# Envia para o branch master
git push origin master

echo "✅ Tudo pronto! Seu código está no GitHub."