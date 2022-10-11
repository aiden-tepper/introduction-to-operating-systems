#! /bin/bash

if ! [[ -x wish ]]; then
    echo "wish executable does not exist"
    exit 1
fi
export TESTS_FOLDER=./tests
export TESTER_FOLDER=./tester

$TESTER_FOLDER/run-tests.sh -d $TESTS_FOLDER $*



