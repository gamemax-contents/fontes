PRODUCT_NAME=$1
BUILD_PATH='build/'$PRODUCT_NAME

HTML_FROM='src/'$PRODUCT_NAME'/index.html'
HTML_TO=$BUILD_PATH'/index.html'

IMG_FROM='src/'$PRODUCT_NAME'/img'
IMG_TO=$BUILD_PATH

FONTS_FROM='src/common/fonts'
FONTS_TO=$BUILD_PATH'/fonts'

CSS_COMOM_FROM='src/common/styles/main.css'
CSS_COMMON_TO=$BUILD_PATH'/styles/main.css'

CSS_CUSTOM_FROM='src/'$PRODUCT_NAME'/styles/custom.css'
CSS_CUSTOM_TO=$BUILD_PATH'/styles/custom.css'

build_project(){
  
  echo $PRODUCT_NAME '-------------'
  
  # Minify Common CSS
  cleancss -o $CSS_COMMON_TO $CSS_COMOM_FROM 
  if [ $? -eq 0 ]; then
    echo '✔ Common CSS minified'
  else
    echo '❌ Common CSS not minified'
  fi

  # Copy Custom Style CSS
  cp -r $CSS_CUSTOM_FROM $CSS_CUSTOM_TO
  if [ $? -eq 0 ]; then
    echo '✔ Custom CSS copied'
  else
    echo '❌ Custom CSS not copied'
  fi

  # Copy IMAGES
  cp -r $IMG_FROM $IMG_TO  
  if [ $? -eq 0 ]; then
    echo '✔ Images copied'
  else
    echo '❌ Images not copied'
  fi
    
  # Copy FONTS
  cp -r $FONTS_FROM $FONTS_TO 
  if [ $? -eq 0 ]; then
    echo '✔ Fonts copied'
  else
    echo '❌ Fonts not minified'
  fi

  # Minify HTML
  html-minifier -o $HTML_TO $HTML_FROM --file-ext html --remove-comments --collapse-whitespace --minify-js true --minify-css true 
  if [ $? -eq 0 ]; then
    echo '✔ HTML minified'
  else
    echo '❌ HTML not minified'
  fi

  # replace commom css url
  OLD_COMMON='\.\.\/common\/styles\/main\.\css'
  NEW_COMMON='styles\/main\.\css'
  sed -i.bak "s/$OLD_COMMON/$NEW_COMMON/g" $BUILD_PATH'/index.html'
  if [ $? -eq 0 ]; then
    echo '✔ fix COMMOM CSS URL in HTML'
  else
    echo '❌ COMMOM CSS URL not fixed'
  fi

  # replace custom css url
  OLD_CUSTOM='\styles\/custom\.\css'
  NEW_CUSTOM='styles\/custom\.\css'
  sed -i.bak "s/$OLD_CUSTOM/$NEW_CUSTOM/g" $BUILD_PATH'/index.html'
  if [ $? -eq 0 ]; then
    echo '✔ fix CUSTOM CSS URL in HTML'
  else
    echo '❌ CUSTOM CSS URL not fixed'
  fi

  #  zip project
  cd build
  zip -r $PRODUCT_NAME'.zip' $PRODUCT_NAME
  if [ $? -eq 0 ]; then
    echo '✔ zip folder'
  else
    echo '❌ folder not ziped'
  fi
}


build_project
if [ $? -eq 0 ]; then
  echo '👏 Build Success'
  echo '\n'
else
  echo '😕 Sorry, build error'
fi





