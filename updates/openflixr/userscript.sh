#!/bin/bash
exec 1> >(tee -a /var/log/userscript.log) 2>&1
TODAY=$(date)
echo "-----------------------------------------------------"
echo "Date:          $TODAY"
echo "-----------------------------------------------------"
