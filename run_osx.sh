#!/bin/bash
MY_PATH="`dirname \"$0\"`"
MY_PATH="`(cd \"$MY_PATH\" && pwd)`"
MY_PATH="`dirname \"$MY_PATH\"`"
cd `dirname $0`

"$MY_PATH"/AzCoreLib/AzOSXCore/azCore /usr/sbin "main.lua"