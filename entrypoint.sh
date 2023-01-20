#!/bin/bash
set -e
/usr/share/dependency-check/bin/dependency-check.sh "${@:1:$#-1}" ${!#}
