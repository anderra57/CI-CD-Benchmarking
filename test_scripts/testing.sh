#!/bin/bash

# Run both tests
path=$(/usr/bin/pwd)
/usr/bin/echo "Running API testing..."
/usr/bin/bash $path/api_testing.sh "John Doe" "Hello World"
exit_code=$(/usr/bin/echo $?)
if [ $exit_code -eq 1 ]; then
    /usr/bin/echo "API testing failed"
    exit 1
fi
/usr/bin/echo "Running security testing..."
/usr/bin/bash $path/security_test.sh
exit_code=$(/usr/bin/echo $?)
if [ $exit_code -eq 1 ]; then
    /usr/bin/echo "Security testing failed"
    exit 1
fi