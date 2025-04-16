#!/bin/bash

# Caminho do diretório do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
