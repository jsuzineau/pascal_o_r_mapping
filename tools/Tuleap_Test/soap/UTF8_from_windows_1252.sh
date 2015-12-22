#!/bin/bash
cd windows_1252
for filename in *.wsdl
do
  iconv -fwindows-1252 -tUTF8 $filename -o../UTF8/$filename".avant_sed"
  sed -e"s/encoding\=\"windows\-1252\"/encoding\=\"UTF-8\"/"  ../UTF8/$filename".avant_sed" > ../UTF8/$filename
  done
cd ..
