#!/bin/bash
set -e

# Captura o nome da pasta atual dinamicamente
NOME_PROJETO=$(basename "$PWD")
USUARIO="renatormendes"
URL_REMOTA="https://github.com"
MENSAGEM=${1:-"Update: $(date +'%d/%m/%Y %H:%M:%S')"}

echo "📂 Projeto Detectado: $NOME_PROJETO"

# 1. Inicializa o Git se não existir
if [ ! -d .git ]; then
    echo "⚙️  Inicializando repositório Git local..."
    git init
    git branch -M master
fi

# 2. Configura ou CORRIGE a URL do Remote
if git remote | grep -q "origin"; then
    echo "🔄 Atualizando link do repositório para: $URL_REMOTA"
    git remote set-url origin "$URL_REMOTA"
else
    echo "🔗 Vinculando novo repositório a: $URL_REMOTA"
    git remote add origin "$URL_REMOTA"
fi

# 3. Processo de envio
echo "🚀 Preparando arquivos..."
git add .

# Verifica se há algo novo para commitar
if git diff-index --quiet HEAD --; then
    echo "ℹ️  Nenhuma alteração detectada para commit."
else
    git commit -m "$MENSAGEM"
fi

# 4. Envio final (Push)
echo "📤 Subindo para o GitHub..."
# O -u garante que o master local siga o master do origin
git push -u origin master

# 5. Resumo Final
echo -e "\n======================================"
echo "✅ OPERAÇÃO CONCLUÍDA COM SUCESSO!"
echo "📂 Pasta Local: $NOME_PROJETO"
echo "🔗 Link GitHub: https://github.com"
echo "📝 Mensagem: $MENSAGEM"
echo "======================================"
