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

installMarkdownPdf () {
  echo "installing markdown-pdf"
  npm install markdown-pdf
}

convertWithPandoc() {
  echo "converting with pandoc..."
  pandoc -o waylay-api.pdf documentation.wiki/Waylay-REST-API-documentation.md
  pandoc -o waylay-broker.pdf documentation.wiki/Submitting-and-fetching-data.md
  pandoc -o waylay-plugins.pdf WaylayPlugins.wiki/Plugin-API.md
}

convertWithMarkdownPdf () {
  echo "converting with markdown-pdf..."
  ./node_modules/.bin/markdown-pdf -o waylay-api.pdf documentation.wiki/Waylay-REST-API-documentation.md
  ./node_modules/.bin/markdown-pdf -o waylay-broker.pdf documentation.wiki/Submitting-and-fetching-data.md
  ./node_modules/.bin/markdown-pdf -o waylay-plugins.pdf WaylayPlugins.wiki/Plugin-API.md
}

installPandocIfNeeded
#installMarkdownPdf

rm -f *.pdf
rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

git clone https://github.com/waylayio/documentation.wiki.git
git clone https://github.com/waylayio/WaylayPlugins.wiki.git

convertWithPandoc
#convertWithMarkdownPdf

rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki

echo "..done, pdf files created:"
ls *.pdf
