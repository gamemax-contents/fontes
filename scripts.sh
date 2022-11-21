
PROJECT_NAME='../build/'${PWD##*/}'_BUILD'

build_project(){

echo $PROJECT_NAME
  
  cleancss -o $PROJECT_NAME/css/main.css css/main.css 
  if [ $? -eq 0 ]; then
    echo '✅ CSS minified'
  else
    echo '❌ CSS not minified'
  fi


  html-minifier -o $PROJECT_NAME/index.html index.html --file-ext html --remove-comments --collapse-whitespace --minify-js true --minify-css true 
  if [ $? -eq 0 ]; then
    echo '✅ HTML minified'
  else
    echo '❌ HTML not minified'
  fi
    

  cp -r img $PROJECT_NAME
  if [ $? -eq 0 ]; then
    echo '✅ Images copied'
  else
    echo '❌ Images not minified'
  fi
    

  cp -r fonts $PROJECT_NAME 
  if [ $? -eq 0 ]; then
    echo '✅ Fonts copied'
  else
    echo '❌ Fonts not minified'
  fi
}

build_project
if [ $? -eq 0 ]; then
  echo '🎉 Build Success'
else
  echo '😕 Sorry, error'
fi