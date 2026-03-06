#!/bin/bash

# Se qualquer comando falhar, o script para imediatamente
set -e

MENSAGEM=${1:-"Update: $(date +'%d/%m/%Y %H:%M:%S')"}

# Garante que estamos em um repositório git
if [ ! -d .git ]; then
    echo "⚙️ Inicializando Git..."
    git init
fi

echo "🚀 Iniciando o envio para o GitHub..."

git add .
git commit -m "$MENSAGEM"

# Tenta enviar. Se falhar, avisa o usuário.
if git push -u origin master; then
    echo "✅ Tudo pronto! Seu código está no GitHub."
else
    echo "❌ Erro: Verifique se o 'remote origin' está configurado corretamente."
    exit 1
fi
