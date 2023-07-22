#!/bin/bash
apt update && apt install -y nano sudo curl wget ssh tree 
echo -e \root\\nroot\\n| passwd root &>/dev/null
