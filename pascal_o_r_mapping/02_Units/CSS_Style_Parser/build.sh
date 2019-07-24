OLD_PWD=$PWD
GENERATED_PATH=$(dirname "$0")/generated
cd $GENERATED_PATH
pwd
plex -v uCSS_Style_Parser_PLEX.l
NDYACC=../../../7_sources_externes/ndyacclex/src/yacc/ndyacc
#orginal pyacc doesn't work,
#it generates "YYSType = record case Integer of" which doesn't work with String token in fpc
#pyacc -v -d uCSS_Style_Parser_PYACC.y

if [ ! -f $NDYACC ]; then
    echo "ndyacc not found!, may be you'll have compile it in: $PWD/$NDYACC"
fi
$NDYACC -v -d uCSS_Style_Parser_PYACC.y
cd $OLD_PWD
