#!/usr/bin/env bash

set -eu

./task.sh | /bin/sh -s -- run_test
curl -fsSL https://raw.githubusercontent.com/Slvr-one/IAC_Dev/main/user_data/