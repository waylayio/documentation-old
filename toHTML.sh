#!/bin/bash
set -e

installPandocIfNeeded () {
  echo "checking if pandoc is installed..."
  if command -v pandoc > /dev/null 2>&1 ; then
    echo "...ok"
  else
    installPandoc
  fi  
}

installPandoc () {
  echo "installing pandoc"
  if [[ $OSTYPE == darwin* ]]; then
    sudo port install pandoc
  else
    sudo apt-get install pandoc texlive-latex-base texlive-fonts-recommended texlive-latex-extra
  fi
}

convertWithPandoc() {
  echo "converting with pandoc..."
  pandoc -s -S --toc -c -A documentation.wiki/Waylay-REST-API-documentation.md -o Waylay-REST-API-documentation.html
  pandoc -s -S --toc -c -A documentation.wiki/Submitting-and-fetching-data.md -o Submitting-and-fetching-data.html
  pandoc -s -S --toc -c -A WaylayPlugins.wiki/Plugin-API.md -o Plugin-API.html
  pandoc -s -S --toc -c -A documentation.wiki/Waylay-starter’s-guide.md -o Waylay-starters-guide.html
  pandoc -s -S --toc -c -A documentation.wiki/Architecture.md -o Architecture.html
  pandoc -s -S --toc -c -A documentation.wiki/Tasks-and-Templates.md -o Tasks-and-Templates.html
   pandoc -s -S --toc -c -A documentation.wiki/Docker-image-guide.md -o Docker-image-guide.html
}

convertToHTML(){
  l=`grep -nr h1 Plugin-API.html | head -1 | cut -f2 -d':'`
  tail -n+$l Plugin-API.html | sed 's/\[TOC\]//g'| sed -e :a -e '$d;N;2,2ba' -e 'P;D' | sed 's/.png"/.png" class="img-responsive" /g'  > temp.html
  cat header.txt temp.html footer.txt > Plugin-API.html 

  l=`grep -nr h1 Waylay-REST-API-documentation.html | head -1 | cut -f2 -d':'`
  tail -n+$l Waylay-REST-API-documentation.html | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D' | sed 's/.png"/.png" class="img-responsive" /g'   > temp.html
  cat header.txt temp.html footer.txt > Waylay-REST-API-documentation.html

  l=`grep -nr h1 Submitting-and-fetching-data.html | head -1 | cut -f2 -d':'`
  tail -n+$l Submitting-and-fetching-data.html | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > temp.html
  cat header.txt temp.html footer.txt > Submitting-and-fetching-data.html

  l=`grep -nr h1 Waylay-starters-guide.html | head -1 | cut -f2 -d':'`
  tail -n+$l Waylay-starters-guide.html  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > temp.html
  cat header.txt temp.html footer.txt > Waylay-starters-guide.html

  l=`grep -nr h1 Architecture.html | head -1 | cut -f2 -d':'`
  tail -n+$l Architecture.html  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > temp.html
  cat header.txt temp.html footer.txt > Architecture.html

  l=`grep -nr h1 Docker-image-guide.html | head -1 | cut -f2 -d':'`
  tail -n+$l Docker-image-guide.html  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > temp.html
  cat header.txt temp.html footer.txt > Docker-image-guide.html

  rm temp.html
}

installPandocIfNeeded
#installMarkdownPdf

rm -f *.html
rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

git clone https://github.com/waylayio/documentation.wiki.git
git clone https://github.com/waylayio/WaylayPlugins.wiki.git

convertWithPandoc
convertToHTML

rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

echo "..done, html files created:"
ls *.html
