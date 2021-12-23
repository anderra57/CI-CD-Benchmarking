#!/bin/bash

# Run both tests
path=$(pwd)
echo $path
bash $path/test_scripts/api_testing.sh "John Doe" "Hello World"
exit_code=$(echo $?)
if [ $exit_code -eq 1 ]; then
    echo "API testing failed"
    exit 1
fi
bash $path/test_scripts/security_test.sh
exit_code=$(echo $?)
if [ $exit_code -eq 1 ]; then
    echo "Security testing failed"
    exit 1
fi
