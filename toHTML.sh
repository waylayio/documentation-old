#!/bin/bash
set -e

WORKDIR="`pwd`/site/"

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
  pandoc -s -S --toc -c -A "documentation.wiki/Waylay-REST-API-documentation.md" -o "${WORKDIR}Waylay-REST-API-documentation.html"
  pandoc -s -S --toc -c -A "documentation.wiki/Submitting-and-fetching-data.md" -o "${WORKDIR}Submitting-and-fetching-data.html"
  pandoc -s -S --toc -c -A "WaylayPlugins.wiki/Plugin-API.md" -o "${WORKDIR}Plugin-API.html"
  pandoc -s -S --toc -c -A "documentation.wiki/Waylay-starter’s-guide.md" -o "${WORKDIR}Waylay-starters-guide.html"
  pandoc -s -S --toc -c -A "documentation.wiki/Architecture.md" -o "${WORKDIR}Architecture.html"
  pandoc -s -S --toc -c -A "documentation.wiki/Tasks-and-Templates.md" -o "${WORKDIR}Tasks-and-Templates.html"
  pandoc -s -S --toc -c -A "documentation.wiki/Docker-image-guide.md" -o "${WORKDIR}Docker-image-guide.html"
}

convertToHTML(){
  l=`grep -nr h1 "${WORKDIR}Plugin-API.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Plugin-API.html" | sed 's/\[TOC\]//g'| sed -e :a -e '$d;N;2,2ba' -e 'P;D' | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Plugin-API.html"

  l=`grep -nr h1 "${WORKDIR}Waylay-REST-API-documentation.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Waylay-REST-API-documentation.html" | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D' | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Waylay-REST-API-documentation.html"

  l=`grep -nr h1 "${WORKDIR}Submitting-and-fetching-data.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Submitting-and-fetching-data.html" | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > ${WORKDIR}Submitting-and-fetching-data.html

  l=`grep -nr h1 "${WORKDIR}Waylay-starters-guide.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Waylay-starters-guide.html"  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Waylay-starters-guide.html"

  l=`grep -nr h1 "${WORKDIR}Architecture.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Architecture.html"  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Architecture.html"

  l=`grep -nr h1 "${WORKDIR}Docker-image-guide.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Docker-image-guide.html"  | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Docker-image-guide.html"

  l=`grep -nr h1 "${WORKDIR}Tasks-and-Templates.html" | head -1 | cut -f2 -d':'`
  tail -n+$l "${WORKDIR}Tasks-and-Templates.html" | sed 's/\[TOC\]//g' | sed -e :a -e '$d;N;2,2ba' -e 'P;D'  | sed 's/.png"/.png" class="img-responsive" /g' > ${WORKDIR}temp.html
  cat header.txt "${WORKDIR}temp.html" footer.txt > "${WORKDIR}Tasks-and-Templates.html"

  rm ${WORKDIR}temp.html
}

listAndCommit(){
  cd ${WORKDIR}
  git status

  read -p "Do you wish to commit the changes? (y/N)" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git commit -a -m "documentation rebuild"
    git push
  fi
}

installPandocIfNeeded
#installMarkdownPdf

rm -rf site
echo "checking out the current site"
mkdir "${WORKDIR}"
git clone git@github.com:waylayio/docs_site.git "${WORKDIR}"

rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

git clone https://github.com/waylayio/documentation.wiki.git
git clone https://github.com/waylayio/WaylayPlugins.wiki.git

convertWithPandoc
convertToHTML

rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

listAndCommit
