#!/bin/bash


if [[ -z $1 ]]
then
echo "backup done"
else if [[ $1 = "mysql" ]]
then
echo "backup done"
dock
else if [[ $1 = "ssh" ]]
then
echo "backup done"
postfix
fi
fi
fi


cd /home/backupuser/ && /home/backupuser/backupscript