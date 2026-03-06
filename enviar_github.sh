#!/bin/bash
set -e

# 1. Identifica o nome da pasta atual e define a URL
NOME_PROJETO=$(basename "$PWD")
USUARIO="renatormendes"
URL_REMOTA="https://github.com"
MENSAGEM=${1:-"Update: $(date +'%d/%m/%Y %H:%M:%S')"}

echo "📂 Projeto: $NOME_PROJETO"

# 2. Inicializa o Git se não existir
if [ ! -d .git ]; then
    echo "⚙️  Inicializando repositório Git local..."
    git init
    git branch -M master
fi

# 3. Configura o Remote se não existir
if ! git remote | grep -q "origin"; then
    echo "🔗 Vinculando a: $URL_REMOTA"
    git remote add origin "$URL_REMOTA"
fi

# 4. Processo de envio
echo "🚀 Preparando envio..."
git add .

# Verifica se há algo para commitar (evita erro se não houver mudanças)
if git diff-index --quiet HEAD --; then
    echo "ℹ️  Nenhuma alteração detectada para commit."
else
    git commit -m "$MENSAGEM"
fi

# 5. Envio final
echo "📤 Subindo para o GitHub..."
git push -u origin master

# 6. Resumo Final
echo -e "\n======================================"
echo "✅ OPERAÇÃO CONCLUÍDA COM SUCESSO!"
echo "📂 Pasta: $NOME_PROJETO"
echo "🔗 Link: https://github.com"
echo "📝 Mensagem: $MENSAGEM"
echo "======================================"

