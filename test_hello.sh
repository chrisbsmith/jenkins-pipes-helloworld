#!/bin/bash

[[ `./hello.sh chris s` = "hello chris s!" ]] && (echo "test passed!"; exit 0) || (echo "test failed :-("; exit 1)


