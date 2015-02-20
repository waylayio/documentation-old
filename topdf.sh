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
    sudo port install pandoc pdflatex
  else
    sudo apt-get install pandoc pdflatex
  fi
}

installPandocIfNeeded

git clone https://github.com/waylayio/documentation.wiki.git
git clone https://github.com/waylayio/WaylayPlugins.wiki.git
ls -al documentation.wiki
ls -al WaylayPlugins.wiki

pandoc -o waylay-api.pdf documentation.wiki/Waylay-REST-API-documentation.md
pandoc -o waylay-broker.pdf documentation.wiki/Submitting-and-fetching-data.md
pandoc -o waylay-plugins.pdf WaylayPlugins.wiki/Plugin-API.md

rm -rf documentation.wiki
rm -rf WaylayPlugins.wiki
