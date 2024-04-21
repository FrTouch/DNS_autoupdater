#!/bin/bash

checkError() {
    return_code=$?
    if [ $return_code -eq 0 ]; then
        echo "  OK"
    else
        echo "Error while executing command, error code : $return_code"
        return $return_code
    fi
}