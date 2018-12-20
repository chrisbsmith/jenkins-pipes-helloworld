#!/bin/bash

[[ `./hello.sh chris` = "hello chris!" ]] && (echo "test passed!"; exit 0) || (echo "test failed :-("; exit 1)


