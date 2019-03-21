#!/usr/bin bash 

JASMINE_HOME="/tmp/jasmine"
JASMINE_BIN="$JASMINE_HOME/bin/jasmineio"

TEST_TARGET_DIR="tests"

if [ ! -d $JASMINE_HOME ]; then
    git clone git@github.com:bekkopen/jasmineio.git $JASMINE_HOME
fi

for file in $TEST_TARGET_DIR/*.io;
do
    if [ ! -f "$file" ]; then
        continue
    fi
    echo "io $JASMINE_BIN $file;"
    io $JASMINE_BIN $file;
done