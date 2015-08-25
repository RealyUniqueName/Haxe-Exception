#!/bin/bash

rm exception.zip
zip -r exception.zip src README.md LICENSE haxelib.json > /dev/null
haxelib submit exception.zip