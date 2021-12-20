#!/bin/bash

/usr/bin/echo "Running API testing..."

root_uri="http://localhost:3000/"

function testGetMethod()
{
    status_code=$(/usr/bin/curl --write-out '%{http_code}' --silent --output /dev/null $root_uri)
    if [ $status_code -eq 200 ]; then
        /usr/bin/echo "GET method is working"
    else
        /usr/bin/echo "GET method is not working"
        exit 1
    fi
}

function testPostMethod()
{
    item_number=$(/usr/bin/curl --silent http://localhost:3000 | /usr/bin/grep -o _id | /usr/bin/wc -l)
    /usr/bin/curl --silent --output /dev/null -X POST $root_uri'item/add' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'name='$1 --data-urlencode 'message='$2
    new_item_number=$(/usr/bin/curl --silent http://localhost:3000 | /usr/bin/grep -o _id | /usr/bin/wc -l)
    if [ $new_item_number -eq $(($item_number + 1)) ]; then
        /usr/bin/echo "POST method is working"
    else
        /usr/bin/echo "POST method is not working"
        exit 1
    fi
}

function testPutMethod()
{
    status_code=$(/usr/bin/curl --write-out '%{http_code}' --silent --output /dev/null -X PUT $root_uri'item/put' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'name='$1 --data-urlencode 'message='$2)
    if [ $status_code -eq 204 ]; then
        /usr/bin/echo "PUT method is working"
    else
        /usr/bin/echo "PUT method is not working"
        exit 1
    fi
}

function testDeleteMethod()
{
    item_number=$(/usr/bin/curl --silent http://localhost:3000 | /usr/bin/grep -o _id | /usr/bin/wc -l)
    /usr/bin/curl --silent --output /dev/null -X DELETE $root_uri'item/delete' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'name='$1
    new_item_number=$(/usr/bin/curl --silent http://localhost:3000 | /usr/bin/grep -o _id | /usr/bin/wc -l)
    if [ $new_item_number -eq $(($item_number - 1)) ]; then
        /usr/bin/echo "DELETE method is working"
    else
        /usr/bin/echo "DELETE method is not working"
        exit 1
    fi
}

if [ $# -eq 2 ]; 
then
    name=$1
    message=$2
    testGetMethod
    testPostMethod $name $message
    testPutMethod $name $message
    testDeleteMethod $name
    /usr/bin/echo "API testing is done"
else
    /usr/bin/echo "[*] Usage: ./api_testing.sh <name> <message>"
fi