#!/bin/bash

YEAR=$1
PRODUCT_NAME=$2

BUILD_PATH="build/$PRODUCT_NAME"
HTML_FROM="src/$YEAR/$PRODUCT_NAME/index.html"
HTML_TO="$BUILD_PATH/index.html"
IMG_FROM="src/$YEAR/$PRODUCT_NAME/img"
FONTS_FROM="src/$YEAR/common/fonts"
CSS_COMMON_FROM="src/$YEAR/common/styles/main.css"

# Função para exibir o resultado de cada comando
check_status() {
  if [ $? -eq 0 ]; then
    echo "✅ $1"
  else
    echo "❌ $2"
    exit 1  # Interrompe o script em caso de erro
  fi
}

build_project() {
  echo "$PRODUCT_NAME -------------"
  echo "Ano: $YEAR"

  # Criação das pastas necessárias
  mkdir -p "$BUILD_PATH/styles" "$BUILD_PATH/fonts"

  # Minificar o CSS comum
  cleancss -o "$BUILD_PATH/styles/main.css" "$CSS_COMMON_FROM"
  check_status "CSS comum minificado" "Erro ao minificar o CSS comum"

  # Copiar imagens
  cp -r "$IMG_FROM" "$BUILD_PATH"
  check_status "Imagens copiadas" "Erro ao copiar as imagens"

  # Copiar fontes
  cp -r "$FONTS_FROM/"* "$BUILD_PATH/fonts"
  check_status "Fontes copiadas" "Erro ao copiar as fontes"

  # Minificar HTML
  html-minifier -o "$HTML_TO" "$HTML_FROM" --file-ext html --remove-comments --collapse-whitespace --minify-js true --minify-css true
  check_status "HTML minificado" "Erro ao minificar o HTML"

  # Substituir URLs no HTML
  sed -i.bak -e 's/\.\.\/common\/styles\/main\.css/styles\/main\.css/g' \
             -e 's/styles\/custom\.css/styles\/custom\.css/g' "$HTML_TO"
  check_status "URLs de CSS corrigidos no HTML" "Erro ao corrigir URLs de CSS no HTML"

  # Compactar o projeto
  (cd build && zip -r "$PRODUCT_NAME.zip" "$PRODUCT_NAME")
  check_status "Projeto compactado" "Erro ao compactar o projeto"
}

build_project
echo '👏 Build concluído com sucesso'
