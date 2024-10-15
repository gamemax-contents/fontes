YEAR=$1
PRODUCT_NAME=$2

BUILD_PATH="build/$PRODUCT_NAME"

HTML_FROM="src/$YEAR/$PRODUCT_NAME/index.html"
HTML_TO="$BUILD_PATH/index.html"

IMG_FROM="src/$YEAR/$PRODUCT_NAME/img"
IMG_TO="$BUILD_PATH"

FONTS_FROM="src/$YEAR/common/fonts"
FONTS_TO="$BUILD_PATH/fonts"

CSS_COMOM_FROM="src/$YEAR/common/styles/main.css"
CSS_COMMON_TO="$BUILD_PATH/styles/main.css"

build_project(){
  
  echo "$PRODUCT_NAME -------------"
  echo "Year: $YEAR"

  # Minify Common CSS
  cleancss -o "$CSS_COMMON_TO" "$CSS_COMOM_FROM" 
  if [ $? -eq 0 ]; then
    echo '✔ Common CSS minified'
  else
    echo '❌ Common CSS not minified'
  fi


  # Copy IMAGES
  cp -r "$IMG_FROM" "$IMG_TO"  
  if [ $? -eq 0 ]; then
    echo '✔ Images copied'
  else
    echo '❌ Images not copied'
  fi
    
  # Copy FONTS
  cp -r "$FONTS_FROM" "$FONTS_TO" 
  if [ $? -eq 0 ]; then
    echo '✔ Fonts copied'
  else
    echo '❌ Fonts not copied'
  fi

  # Minify HTML
  html-minifier -o "$HTML_TO" "$HTML_FROM" --file-ext html --remove-comments --collapse-whitespace --minify-js true --minify-css true 
  if [ $? -eq 0 ]; then
    echo '✔ HTML minified'
  else
    echo '❌ HTML not minified'
  fi

  # Replace common CSS URL in HTML
  OLD_COMMON='\.\.\/common\/styles\/main\.\css'
  NEW_COMMON='styles\/main\.\css'
  sed -i.bak "s/$OLD_COMMON/$NEW_COMMON/g" "$BUILD_PATH/index.html"
  if [ $? -eq 0 ]; then
    echo '✔ fix COMMON CSS URL in HTML'
  else
    echo '❌ COMMON CSS URL not fixed'
  fi

  # Replace custom CSS URL in HTML
  OLD_CUSTOM='styles\/custom\.\css'
  NEW_CUSTOM='styles\/custom\.\css'
  sed -i.bak "s/$OLD_CUSTOM/$NEW_CUSTOM/g" "$BUILD_PATH/index.html"
  if [ $? -eq 0 ]; then
    echo '✔ fix CUSTOM CSS URL in HTML'
  else
    echo '❌ CUSTOM CSS URL not fixed'
  fi

  # Zip project
  cd build
  zip -r "$PRODUCT_NAME.zip" "$PRODUCT_NAME"
  if [ $? -eq 0 ]; then
    echo '✔ zip folder'
  else
    echo '❌ folder not zipped'
  fi
}

build_project
if [ $? -eq 0 ]; then
  echo '👏 Build Success'
  echo '\n'
else
  echo '😕 Sorry, build error'
fi
