#!/bin/bash
# Interrompe o script se houver qualquer erro
set -e

# 1. Configurações de Identidade
USUARIO="renatormendes"
NOME_PROJETO=$(basename "$PWD")
# Montagem explícita da URL
URL_REMOTA="https://github.com/${USUARIO}/${NOME_PROJETO}.git"
MENSAGEM=${1:-"Update: $(date +'%d/%m/%Y %H:%M:%S')"}

echo "------------------------------------------"
echo "📂 Projeto: $NOME_PROJETO"
echo "🔗 Destino: $URL_REMOTA"
echo "------------------------------------------"

# 2. Inicializa o Git se necessário
if [ ! -d .git ]; then
    echo "⚙️  Inicializando Git local..."
    git init
    git branch -M master
fi

# 3. Força a atualização da URL do Remote (Resolve o erro do link quebrado)
if git remote | grep -q "origin"; then
    git remote set-url origin "$URL_REMOTA"
else
    git remote add origin "$URL_REMOTA"
fi

# 4. Adiciona e Commita
echo "🚀 Preparando arquivos..."
git add .

# Verifica se há algo para commitar
if git diff --cached --quiet; then
    echo "ℹ️  Nada novo para commitar."
else
    git commit -m "$MENSAGEM"
fi

# 5. Push final
echo "📤 Subindo para o GitHub..."
git push -u origin master

# 6. Resumo Final
echo -e "\n=========================================="
echo "✅ SUCESSO NO ENVIO!"
echo "📂 Pasta: $NOME_PROJETO"
echo "🌐 Confira em: https://github.comUSUARIO/$NOME_PROJETO"
echo "=========================================="
