#!/usr/bin sh 

JASMINE_HOME="/tmp/jasmine"
JASMINE_BIN="$JASMINE_HOME/bin/jasmineio"

TEST_TARGET_DIR="tests"

if [ ! -d $JASMINE_HOME ]; then
    git clone https://github.com/bekkopen/jasmineio.git $JASMINE_HOME
fi

for file in $TEST_TARGET_DIR/*.io;
do
    if [ ! -f "$file" ]; then
        continue
    fi

    stdout="$(io $JASMINE_BIN $file)";
    status=$?

    echo "$stdout"

    if [ ! $status -eq 0 ]; then
        exit $status
    fi
done