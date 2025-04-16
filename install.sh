#!/bin/bash

# Uso: ./install.sh [PASTA_DE_DESTINO]
# Ou defina a variável de ambiente DOTFILES_DEST_DIR

# Define a pasta de destino
if [ -n "$1" ]; then
  DEST_DIR="$1"
elif [ -n "$DOTFILES_DEST_DIR" ]; then
  DEST_DIR="$DOTFILES_DEST_DIR"
else
  DEST_DIR="$HOME/dotfiles"
fi
DEST_DIR=${DEST_DIR/#\~/$HOME} # Expande ~ para $HOME
REPO_URL="https://github.com/ribeiroevandro/dotfiles.git" # Substitua pelo seu repositório

echo "[INFO] Usando a pasta de destino: $DEST_DIR"

# Clona o repositório se a pasta não existir
if [ ! -d "$DEST_DIR" ]; then
  echo "Clonando repositório em $DEST_DIR..."
  git clone "$REPO_URL" "$DEST_DIR"
else
  echo "[OK] Pasta de destino já existe: $DEST_DIR"
fi

# Caminho do diretório do script
SCRIPT_DIR="$DEST_DIR"
DOTFILES_DIR="$SCRIPT_DIR"
ZSHRC_SOURCE="$DOTFILES_DIR/zsh/zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
EAS_CREDENTIALS="$HOME/.eas_credentials"

# 1. Verifica se .zshrc existe no home
if [ -e "$ZSHRC_TARGET" ]; then
  echo "[OK] $ZSHRC_TARGET já existe."
else
  ln -s "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  echo "[INFO] Link simbólico criado: $ZSHRC_TARGET -> $ZSHRC_SOURCE"
fi

# 2. Verifica se .eas_credentials existe no home
if [ ! -f "$EAS_CREDENTIALS" ]; then
  echo "[AVISO] O arquivo $EAS_CREDENTIALS é necessário e não foi encontrado. Crie este arquivo com suas credenciais."
fi
