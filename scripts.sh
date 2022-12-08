PRODUCT_NAME=$1
BUILD_PATH='build/'$PRODUCT_NAME

HTML_FROM='src/'$PRODUCT_NAME'/index.html'
HTML_TO=$BUILD_PATH'/index.html'

IMG_FROM='src/'$PRODUCT_NAME'/img'
IMG_TO=$BUILD_PATH

IMG_COMMON_FROM='src/common/img'
IMG_COMMON_TO=$BUILD_PATH

FONTS_FROM='src/common/fonts'
FONTS_TO=$BUILD_PATH'/fonts'

CSS_FROM='src/common/css/main.css'
CSS_TO=$BUILD_PATH'/css/main.css'


build_project(){
  
  echo $PRODUCT_NAME
  
  # Minify CSS
  cleancss -o $CSS_TO $CSS_FROM 
  if [ $? -eq 0 ]; then
    echo '✔ CSS minified'
  else
    echo '❌ CSS not minified'
  fi

  # Copy IMAGES
  cp -r $IMG_FROM $IMG_TO  
  if [ $? -eq 0 ]; then
    echo '✔ Images copied'
  else
    echo '❌ Images not copied'
  fi

  # Copy Common IMAGES
  cp -r $IMG_COMMON_FROM $IMG_COMMON_TO  
  if [ $? -eq 0 ]; then
    echo '✔ Common Images copied'
  else
    echo '❌ Common Images not copied'
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

  # replace css url
  OLD='\.\.\/common\/css\/main\.\css'
  NEW='css\/main\.\css'
  sed -i.bak "s/$OLD/$NEW/g" $BUILD_PATH'/index.html'
  if [ $? -eq 0 ]; then
    echo '✔ fix CSS URL in HTML'
  else
    echo '❌ CSS URL not fixed'
  fi
}


build_project
if [ $? -eq 0 ]; then
  echo '👏 Build Success'
  echo '\n'
else
  echo '😕 Sorry, build error'
fi





