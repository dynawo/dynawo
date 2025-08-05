#!/bin/bash

python3 findAllBlocks.py Modelica/Dynawo | sort | cut -d ' ' -f 1 | uniq > allBlocks.txt
